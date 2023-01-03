import {
  BaseFilter,
  DduItem,
  SourceOptions,
} from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";
import { basename } from "https://deno.land/std/path/mod.ts";
import { Denops } from "https://deno.land/x/ddu_vim@v2.0.0/deps.ts";

type Params = {
  visibleDotFiles: boolean;
};

export class Filter extends BaseFilter<Params> {
  // deno-lint-ignore require-await
  override async filter(args: {
    denops: Denops;
    sourceOptions: SourceOptions;
    filterParams: Params;
    input: string;
    items: DduItem[];
  }): Promise<DduItem[]> {
    let files = args.items.filter((item) => !item.isTree);
    let dirs = args.items.filter((item) => item.isTree);

    console.log(args.filterParams.visibleDotFiles);
    if (!args.filterParams.visibleDotFiles) {
      files = files.filter((item) => !basename(item.word).startsWith("."));
      dirs = dirs.filter((item) => !basename(item.word).startsWith("."));
    }

    files.sort((a, b) => a.word.localeCompare(b.word));
    dirs.sort((a, b) => a.word.localeCompare(b.word));

    return Promise.resolve([...dirs, ...files]);
  }

  override params(): Params {
    return {
      visibleDotFiles: false,
    };
  }
}
