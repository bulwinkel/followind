FollowingWind: A Tailwind CSS like implementation for Flutter
===

> WARNING: This is a work in progress and is not ready for production use. Breaking changes will
> occur regularly.

FollowingWind is a Flutter package that provides a Tailwind CSS like implementation for Flutter. It
is designed to be a simple and easy to use way to style your Flutter applications.

This package is inspired by [Tailwind CSS](https://tailwindcss.com/), a utility-first CSS framework
for rapidly building custom designs.

Not designed to be a 1:1 implementation of Tailwind CSS, FollowingWind aims to provide a similar
experience for Flutter developers but with an API that is familiar for Flutter developers.

Initially, FollowingWind will focus on providing utility classes that map the Flutter's existing
capabilities. Should this project live long enough and see enough interest, it could evolve to add
features missing from the framework.

## Tasks

### Core

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
