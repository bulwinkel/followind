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

# Questions
- [ ] Can we abstract away the lookup strategy so we can worry about performance later without having to do a total rebuild?
    - maybe add a lookup function to the inhereted widget, e.g.
    ```
    FollowingWind.of(context).lookup('bg', classes)
    ```


# Notes
## Architecture
8/12/2024 Attempting to use parser's instead of widgets so we can parse all the classes in one go and then build the widgets. We can also use the parser to generate a key if we want to optimize for performance.

## Limitations
### Borders
- Flutter doesn't natively support anything but solid borders, so no dashed or dotted.
- Flutter doesn't support different border colors per side if corners are rounded.


## Class types
### Single value
Some classes you only take a single value for that type, e.g. bg-color
Once we find a value for that class, we don't need to look for any more classes of that type.

### Cumulative values classes
Others more specific values override less specific classes, e.g. p-4 is partially overridden by px-2 which is partially overridden by pt-1

List of cumulative classes
- padding (p, px, py, pb, pl, pr, pt)
- margin (m, mx, my, mb, ml, mr, mt)
- border (border, border-t, border-r, border-b, border-l)
- border-radius (rounded, rounded-t, rounded-r, rounded-b, rounded-l)

### Composite classes
`border` works on its own to specify a border of 1px on all sides
`border-x border-x-white` work together to specify a border of 1px on the left and right sides and the default color is overridden by white.

### Class segments
The segments of a class are the parts separated by a `-`.
There is no fixed number of segments in a class, 
and no fixed distribution between type and value.

#### 1 Segment type, rest value, e.g. <type>-<value-part>[-<value-part> ...]
For example, `bg-white bg-red-500` bg is the type and white and red-500 are the values.
For rounded, `rounded-xl rounded-t-xl`

For cumulative values, you might have 2, 3 and 4 segment variants, e.g.  

## Interaction modifiers (todo: what is the proper name for this?)
e.g. `hover:`

Changes are not animated by default, i.e. applying rounded on hover it will transition immediately, not animate between the states.

## Size classes / responsive modifiers, e.g. `sm md lg xl`
Starts small and gets larger.

**No prefix** is less than 640px wide and generally refers to mobile screens. 
Classes without any prefix are always applied.

**A prefix** is applied when the minimum screen size for that size class is reached and continue to apply any greater width.

### Priority
Size classes from greater widths take priority over smaller widths, e.g. `sm` is overridden by `md`. But are also cumulative in their normal way, e.g. `p-4` is cumulative with `md:px-2` resulting in a BLRT padding of (4, 2, 2, 4) on `md` screens and up and (4, 4, 4, 4) on `sm` screens and below.

Priority replacement happens based on the type segments, excluding the value segments.
e.g. `rounded-tr-xl`
