FollowingWind: The ergonomics of Tailwind CSS for Flutter
===

> WARNING: This is a work in progress and is not ready for production use. Breaking changes will
> occur regularly.

FollowingWind is a Flutter package that provides a [Tailwind CSS](https://tailwindcss.com/) like
development experience for Flutter.
It is designed to mimic the ergonomics of Tailwind but be idiomatic for Flutter.
It should be familiar enough to both Tailwind users and Flutter developers.

It is not designed to be a 1:1 implementation of Tailwind CSS in Flutter.
The flex layout model in Flutter is different enough from CSS that a direct port is not feasible (at
least in the short term).
Instead, FollowingWind aims to provide a similar development experience but aligned with Flutter's
existing capabilities.

Where possible we will try to align with Tailwind's class names and values.
This will make it easier for developers familiar with Tailwind to use FollowingWind and vice versa.
It will also (hopefully) improve the utility of AI development tools like Copilot and Cursor.

Where this is not possible, we will try to provide a similar experience.

Should this project live long enough and see enough interest, it could evolve to add
features missing from the framework.

In alignment with Tailwind's philosophy, FollowingWind will aim to be interopable with Flutter's
existing Widget system, so that if something is not possible with FollowingWind, you can always
fall back to Flutter's native capabilities.

## Tasks

### Core
- [x] Config entry point
  - [x] Allow the children to look up using an inhereted widget
  - [-] Pre-calculate all the sizes based on config or defaults

- [ ] flex row and column
    - [x] gap
    - [x] main axis alignment
    - [x] cross axis alignment
    - [ ] expanded
        - [ ] apply on child
        - [ ] from parent for all children
    - [ ] flexible - apply on child (should we be able to apply this on a parent?)
- [ ] Finish classes that map to a decorated box
    - [x] color
    - [x] border radius
    - [ ] border
    - [ ] shadow
    - [ ] gradient
- [ ] opacity
- [ ] Introduce responsive prefixes (sm, md, lg, xl)
- [-] Text classes
    - [-] in a box (also styles icons to match)
        - [x] color
        - [x] size
        - [x] text align

### Animations

- [ ] How do animations work in tailwind?
- [ ] Can we make animating flex containers as easy as adding a class? (e.g. "row animated")

### Performance

- [ ] Investigate using classname as the key

### Lint warnings

- [ ] Border radius can only be applied when border is of a uniform color (tailwind / css support
  this)

## Notes

### Border

### Limitations

- Flutter doesn't natively support anything but solid borders, so no dashed or dotted.
- Flutter doesn't support different border colors per side if corners are rounded.
