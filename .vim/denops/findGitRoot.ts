import { join } from "https://deno.land/std/path/mod.ts";

const exists = async (filepath: string): Promise<boolean> => {
  try {
    await Deno.lstat(filepath);
    return true;
  } catch (error) {
    if (error instanceof Deno.errors.NotFound) {
      return false;
    } else {
      throw error;
    }
  }
};

export const findGitRoot = async (
  filepath = Deno.cwd(),
): Promise<string | undefined> => {
  let current = filepath;
  let parent = join(current, "..");

  for (; parent! !== current; parent = join(current, "..")) {
    if (await exists(join(current, ".git"))) {
      return current;
    }
    current = parent!;
  }
};
