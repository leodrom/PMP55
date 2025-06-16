# PMP-55

This repository is a historical snapshot of a static web site called **"PMP-55"**. It contains only HTML, images and a Pascal program used to generate some of the pages.
## General Structure

- The main entry point is `index.html`, which defines a frame-based layout with a navigation frame (`NAVY`) and a main content frame (`MAIN`).
- Most content lives under four directories:
  - `NAVY/` – navigation pages with links and small face images, generated via templates. For example, `E-PMP-55.HTM` lists links to each member page.
  - `MAIN/` – English versions of some member pages (`E-*.HTM`) and Ukrainian versions (`U-*.HTM`).
  - `HOME/` – subdirectories for each member (such as `HOME/ANDY_MAX/`, `HOME/SARA/`, `HOME/TRUSHA/`) containing personal pages and images.
  - `IMAGES/` – shared graphics and a `FACES/` subfolder with small GIF portraits.
- Auxiliary files include `S-MAKE.PAS` (a Pascal program) and `S-MAKE.DAT` (data used by the generator). These are used to create the navigation pages.

## Important Points

- The site uses old-style frames. `index.html` loads `NAVY/U-PMP-55.HTM` by default in the navigation frame and `BLANK.HTM` in the main frame.
- Each member folder under `HOME/` contains personal pages in English and/or Ukrainian with accompanying images.
- `S-MAKE.PAS` replaces markers in template files (`NAVY/!E.HTM`, `NAVY/!U.HTM`) using data from `S-MAKE.DAT` to generate navigation pages.
- The site is purely static; there is no server-side logic or modern web framework involved.

## Where to Go Next

- Review the Pascal code in `S-MAKE.PAS` and the template syntax in `NAVY/!E.HTM` and `NAVY/!U.HTM` to understand how navigation pages were generated.
- Explore individual member directories under `HOME/` and `MAIN/` to see how content was structured. Many pages are in Ukrainian; some have English versions.
- Familiarize yourself with early web practices like frame sets and small animated GIFs.
- To rebuild the site, you would need a Pascal compiler (e.g., FreePascal) to compile `S-MAKE.PAS` and then run `NAVY/CREATE.BAT`, which regenerates the navigation pages from `S-MAKE.DAT`.

