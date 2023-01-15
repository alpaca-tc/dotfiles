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
import { fn } from "https://deno.land/x/ddu_vim@v2.2.0/deps.ts";
import { findGitRoot } from "../findGitRoot.ts";

type Params = Record<string, unknown>;

type FoldItem = DduItem & Item<FileActionData>;

export class Filter extends BaseFilter<Params> {
  override async filter(args: FilterArguments<Params>): Promise<DduItem[]> {
    const items: FoldItem[] = [];
    const dir = await fn.getcwd(args.denops) as string;
    const homeDir = await args.denops.call("expand", "~") as string;
    const repoDir = await findGitRoot(dir);

    args.items.forEach((item) => {
      // /Users/hiroyuki.ishii/.local/share/nvim/site/pack/packer/opt/ddu-source-mr/denops/@ddu-sources/mr.ts
      switch (item.__sourceName) {
        // case 'file':
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
              dir,
              homeDir,
              repoDir,
              item as Item<FileActionData>,
            ),
          );
          break;
        default:
          console.log(`not supported source given ${item.__sourceName}`);
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

  private foldItemForRg(
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

    const word = `${path}:${action.lineNr}:${action.col}: ${action.text}`;

    return { ...item, display: word } as FoldItem;
  }
}
