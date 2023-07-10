import {
  BaseFilter,
  DduItem,
  Item,
} from "https://deno.land/x/ddu_vim@v2.2.0/types.ts";
// import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.3.2/file.ts";
// import { Item } from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";
import { FilterArguments } from "https://deno.land/x/ddu_vim@v2.0.0/base/filter.ts";
import { ActionData as FileActionData } from "https://deno.land/x/ddu_kind_file@v0.3.2/file.ts";
import { relative } from "https://deno.land/std@0.122.0/path/mod.ts";
import * as LSP from "npm:vscode-languageserver-types@3.17.3";
import { fn } from "https://deno.land/x/ddu_vim@v2.2.0/deps.ts";
import { findGitRoot } from "../findGitRoot.ts";

type Params = Record<string, unknown>;

type FoldItem = DduItem & Item<FileActionData>;

type LspActionData = {
  path: string;
  word: string;
  range: LSP.Range;
  lnum?: number; // 1-index
  col?: number; // 1-index
};

function charposToBytepos(input: string, pos: number): number {
  return (new TextEncoder()).encode(input.slice(0, pos)).length;
}

export class Filter extends BaseFilter<Params> {
  override async filter(args: FilterArguments<Params>): Promise<DduItem[]> {
    const items: FoldItem[] = [];
    const dir = await fn.getcwd(args.denops) as string;
    const homeDir = await args.denops.call("expand", "~") as string;
    const repoDir = await findGitRoot(dir);

    args.items.forEach((item) => {
      // /Users/hiroyuki.ishii/.local/share/nvim/site/pack/packer/opt/ddu-source-mr/denops/@ddu-sources/mr.ts
      switch (item.__sourceName) {
        case "mr": {
          items.push(
            this.foldItemForMr(
              dir,
              homeDir,
              repoDir,
              item as Item<FileActionData>,
            ),
          );
          break;
        }
        case "rg":
          items.push(
            this.foldItemForRg(
              args,
              dir,
              homeDir,
              repoDir,
              item as Item<FileActionData>,
            ),
          );
          break;
        case "qf":
          items.push(
            this.foldItemForQf(
              args,
              dir,
              homeDir,
              repoDir,
              item as Item<FileActionData>,
            ),
          );
          break;
        case "lsp_workspaceSymbol": {
          items.push(
            this.foldItemForLspWorkspaceSymbol(
              args,
              dir,
              homeDir,
              repoDir,
              item as Item<LspActionData>,
            ),
          );
          break;
        }

        default:
          console.log(
            `[fold_path] not supported source given ${item.__sourceName}`,
          );
      }
    });

    return items;
  }

  override params(): Params {
    return {};
  }

  private foldItemForMr(
    dir: string,
    homeDir: string,
    repoDir: string | undefined,
    item: Item<FileActionData>,
  ) {
    const path = item.word;
    let word = item.word;

    if (repoDir && word.startsWith(repoDir)) {
      word = relative(dir, path);
    }

    if (word.startsWith(homeDir)) {
      word = `~${word.slice(homeDir.length)}`;
    }

    return { ...item, word } as FoldItem;
  }

  private foldItemForQf(
    args: FilterArguments<Params>,
    dir: string,
    homeDir: string,
    repoDir: string | undefined,
    item: Item<FileActionData>,
  ) {
    const action = item.action!;
    let path = action.path!;
    const prefix = `${action.path}:${action.lineNr}: `;
    const word = action.text!.substring(prefix.length);

    if (repoDir && path.startsWith(repoDir)) {
      path = relative(dir, path);
    }

    if (path.startsWith(homeDir)) {
      path = `~${path.slice(homeDir.length)}`;
    }

    const text = `${path}:${action.lineNr}: ${word}`;

    const highlights: Item["highlights"] = [
      {
        name: "path",
        hl_group: "Directory",
        col: 1,
        width: path.length,
      },
      {
        name: "lineNr",
        hl_group: "Directory",
        col: `${path}:`.length + 1,
        width: String(action.lineNr).length,
      },
      {
        name: "word",
        hl_group: "Normal",
        col: `${path}:${action.lineNr}: `.length + 1,
        width: word.length,
      },
    ];

    const patterns = this.getInputPatterns(args.input);

    for (const pattern of patterns) {
      [...text.matchAll(pattern)].forEach((match) => {
        if (match.index) {
          highlights.push({
            name: "matched",
            hl_group: "Statement",
            col: charposToBytepos(text, match.index) + 1,
            width: (new TextEncoder()).encode(match[0]).length,
          });
        }
      });
    }

    return {
      ...item,
      action: { ...action, text },
      word: text,
      highlights,
    } as FoldItem;
  }

  private foldItemForLspWorkspaceSymbol(
    args: FilterArguments<Params>,
    dir: string,
    homeDir: string,
    repoDir: string | undefined,
    item: Item<LspActionData>,
  ) {
    const textParserRe = /^\[(?<kind>[^\]]+)\]\s+(?<name>.*)$/;
    const { groups } = item.word.match(textParserRe)!;

    const action = item.action!;
    let path = action!.path;

    if (repoDir && path.startsWith(repoDir)) {
      path = relative(dir, path);
    }

    if (path.startsWith(homeDir)) {
      path = `~${path.slice(homeDir.length)}`;
    }

    const kind = groups!["kind"];
    const name = groups!["name"];
    let prefix = path;

    if (action.range) {
      prefix = `${prefix}:${action.range.start.line + 1}: `;
    }

    const text = `${prefix} [${kind}] ${name}`;

    const highlights: Item["highlights"] = [];

    highlights.push(
      {
        name: "path",
        hl_group: "Directory",
        col: 1,
        width: path.length,
      },
    );

    if (action.range) {
      highlights.push({
        name: "lineNr",
        hl_group: "Directory",
        col: `${path}:`.length + 1,
        width: String(action.range.start.line + 1).length,
      });
    }

    highlights.push(
      {
        name: "kind",
        hl_group: "Keyword",
        col: prefix.length + 3,
        width: kind.length,
      },
    );

    highlights.push(
      {
        name: "word",
        hl_group: "Normal",
        col: prefix.length + 2 + kind.length + 2,
        width: name.length,
      },
    );

    const patterns = this.getInputPatterns(args.input);

    for (const pattern of patterns) {
      [...text.matchAll(pattern)].forEach((match) => {
        if (match.index) {
          highlights.push({
            name: "matched",
            hl_group: "Statement",
            col: charposToBytepos(text, match.index) + 1,
            width: (new TextEncoder()).encode(match[0]).length,
          });
        }
      });
    }

    return {
      ...item,
      action: { ...action, text },
      word: text,
      highlights,
    } as FoldItem;
  }

  private foldItemForRg(
    args: FilterArguments<Params>,
    dir: string,
    homeDir: string,
    repoDir: string | undefined,
    item: Item<FileActionData>,
  ) {
    const action = item.action!;
    let path = action.path!;

    if (repoDir && path.startsWith(repoDir)) {
      path = relative(dir, path);
    }

    if (path.startsWith(homeDir)) {
      path = `~${path.slice(homeDir.length)}`;
    }

    const display = `${path}:${action.lineNr}:${action.col}: ${action.text}`;
    const highlights = (item.highlights ?? []).map((highlight) => {
      switch (highlight.name) {
        // recalculate highlight width/col
        // see https://github.com/shun/ddu-source-rg//blob/6b5e5905d5b5d6059ee3ddbcc9fe946f7a89dded/denops/@ddu-sources/rg.ts#L76
        case "path": {
          return {
            ...highlight,
            width: path.length,
          };
        }
        case "lineNr": {
          return {
            ...highlight,
            col: path.length + 2,
            width: String(action.lineNr).length,
          };
        }
        case "word":
        case "matched": {
          // ignore
          break;
        }
        default:
          return highlight;
      }
    }).filter(Boolean);

    const patterns = this.getInputPatterns(args.input);

    for (const pattern of patterns) {
      [...display.matchAll(pattern)].forEach((match) => {
        if (match.index) {
          highlights.push({
            name: "matched",
            hl_group: "Statement",
            col: charposToBytepos(display, match.index) + 1,
            width: (new TextEncoder()).encode(match[0]).length,
          });
        }
      });
    }

    return { ...item, display, word: display, highlights } as FoldItem;
  }

  private getInputPatterns(input: string): RegExp[] {
    const inputs = input.split(/(?<!\\)\s+/).filter((x) => x != "").map((x) =>
      x.replaceAll(/\\(?=\s)/g, "")
    );
    const patterns: RegExp[] = [];

    for (const input of inputs) {
      try {
        patterns.push(new RegExp(input, "ig"));
      } catch (_) {
        // ignore
      }
    }

    return patterns;
  }
}
