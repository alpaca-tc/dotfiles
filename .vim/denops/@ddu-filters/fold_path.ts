import {
  BaseFilter,
  DduItem,
} from "https://deno.land/x/ddu_vim@v2.2.0/types.ts";
// import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.3.2/file.ts";
// import { Item } from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";
import { FilterArguments } from "https://deno.land/x/ddu_vim@v2.0.0/base/filter.ts";

type Params = Record<string, unknown>;

export class Filter extends BaseFilter<Params> {
  override filter(args: FilterArguments<Params>): Promise<DduItem[]> {
    const items: DduItem[] = [];

    args.items.forEach((item) => {
      // /Users/hiroyuki.ishii/.local/share/nvim/site/pack/packer/opt/ddu-source-mr/denops/@ddu-sources/mr.ts
      switch (item.__sourceName) {
        // case 'file':
        // case 'mr':
        // case 'rg':
        default:
          console.log(`not supported source given ${item.__sourceName}`);
      }
    });

    return Promise.resolve(args.items);
  }

  override params(): Params {
    return {};
  }
}
