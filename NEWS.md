# jpmesh 1.2.0 (2020-03-26)

- API changes to functions that take `mesh_size` ([#35](https://github.com/uribo/jpmesh/issues/35)). It has been changed to a numeric value in km unit instead of the mesh size string.

```r
coords_to_mesh(141.3468, 43.06462, mesh_size = "10km")
```

to

```r
coords_to_mesh(141.3468, 43.06462, mesh_size = 10)
```

- Add `mesh_convert()` that mesh size can be changed freely.

```r
# Scale up
mesh_convert("52350432", 80)
# Scale down
mesh_convert("52350432", 0.500)
```

## Improvement

- Add image test with vdiffr ([#41](https://github.com/uribo/jpmesh/pull/41)).
- Introducing GitHub actions.

## Bug fixes and minor improvements

- The bounding box value returned by `mesh_to_coords()` is incorrect ([#31](https://github.com/uribo/jpmesh/issues/31))

# jpmesh 1.1.3 (2019-05-09)

- Fix R version test.

# jpmesh 1.1.2 (2019-03-20)

- Fix devel version's test.

# jpmesh 1.1.1 (2018-06-26)

- Withdrawal from the tidyverse. Remove depends on stringr, tidyr and dplyr.
- Follow up the units package update.
- Fixed overlapped probrem ([#20](https://github.com/uribo/jpmesh/issues/20))

## New features

- `coarse_gather()`... Scale-down function [#22](https://github.com/uribo/jpmesh/issues/22)

# jpmesh 1.1.0 (2018-02-25)

- Support units system ([#15](https://github.com/uribo/jpmesh/issues/15))
- Bug fixed ([#13](https://github.com/uribo/jpmesh/issues/13))
- All return mesh code should be character.
- Set sf object espg as `4326`.

## New features

- `is_meshcode()`, `is_corner()`... Predict meshcode format and positions for utility and certain.
- `rmesh()`... 
- Rename `find_neighbor_mesh()` to `neighbor_mesh()` and separate features (not export functions).
- `export_meshes()`

# jpmesh 1.0.1 (2017-12-04)

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
