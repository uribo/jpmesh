# jpmesh 1.0.1

- add vignettes 1: How to use mesh cord in R

## Bug fixes and minor improvements

- Fixed incorrect allocation of fine mesh code number ([#8](https://github.com/uribo/jpmesh/issues/8)).
- Modified `eval_jp_boundary()` that internal function.
    - Add ... parameters to pass additional arguments.
    - Improved problem of giving mesh code outside of Japan (reopen [#6](https://github.com/uribo/jpmesh/issues/6)).
- `fine_separate()`... Correct behavior when entering 1 km meshcode ([#9](https://github.com/uribo/jpmesh/issues/9)).

# jpmesh 1.0.0 (2017-11-27)

- Consolidation of functions by integration and abolition. Rename of function name. Such as, argument order.
- You can now convert coordinates to 125m meshcode. As a result, it became to support to all meshcodes.
- Update Polygon Export Function (`export_mesh`)

# jpmesh 0.4.0 (2017-09-01)

- Using sf api.
- Add new dataset.
    - `jpnrect`... Japan Prefecture Mesh Data.
    - `prefecture_mesh`
- Enhanced CI and coverage environment (#5).
- Fix some issues (#6).
- Add new functions
    - `pref_mesh()` replicate to `administration_mesh()`
    - `find_neighbor_mesh()`... Find out neighborhood meshes.
    - `mesh_rectangle()`... Output mesh rectange.

# jpmesh 0.3.0 (2016-11-12)

## New Features

- Mesh viewer as shiny gadgets (`mesh_viewer()`) #4
- Export mesh rectangle as geojson (`export_mesh()`) #3

# jpmesh 0.2.0

## New Features

- Added simple Japan grid datasets.

## Improve Infrastructures

- Making website by `pkgdown`.

# jpmesh 0.1.0

- Added a `NEWS.md` file to track changes to the package.
- Added base functions.
