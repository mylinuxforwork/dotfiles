# Waybar Style Guide

This style guide defines conventions, best practices, and design principles for customizing and maintaining the `style.css` and related configuration for [Waybar](https://github.com/Alexays/Waybar) within the `mylinuxforwork/dotfiles` repository. Follow this guide to ensure a consistent, readable, and easily maintainable look and feel, especially when collaborating or sharing your config.

---

## Table of Contents

1. [General Principles](#general-principles)
2. [File Structure](#file-structure)
3. [CSS Conventions](#css-conventions)
4. [Naming Conventions](#naming-conventions)
5. [Color Scheme & Theming](#color-scheme--theming)
6. [Module Styling](#module-styling)
7. [Responsive Design](#responsive-design)
8. [Custom Widgets](#custom-widgets)
9. [Accessibility](#accessibility)
10. [Versioning and Comments](#versioning-and-comments)

---

## 1. General Principles

- **Consistency**: Keep all styles consistent across modules (padding, font, border radius, etc.).
- **Minimalism**: Prefer clean, minimal designs. Avoid unnecessary shadows or excessive gradients.
- **Readability**: Prioritize clarity in both the UI and the CSS code.
- **Maintainability**: Write CSS that is easy to extend, reuse, or modify.
- **Performance**: Avoid expensive CSS selectors or unnecessary animations.

---

## 2. File Structure

Organize your Waybar configuration as follows:

```
~/.config/waybar/
  ├── colors.css
  ├── modules.json
  └── themes/
        └── theme-name/
               ├── theme-variant/
               |      ├── style.css
               |      └── config.sh
               |
               ├── style.css
               └── config
```

- **`style.css`** imports colors from `colors.css` and contains general styling which is modified in variant `style.css`.
- **`style.css`** of theme-variant imports theme `style.css` and contains base overrides.
- **Theme Name** should be defined in `config.sh`
- **Themes** are separated in `themes/` for easy switching and modularity.
- **Scripts** for custom modules go in `modules.json`.

---

## 3. CSS Conventions

- **Indentation**: Use 2 spaces per indentation level.
- **Selector Specificity**: Prefer class selectors over IDs. Chain selectors for modules (e.g., `.module.cpu`).
- **Ordering**: Style modules in the order they appear in the bar for easier navigation.
- **Units**: Use `px` for pixel-precise elements, `em` or `%` for scalable properties.
- **Variables**: Use CSS variables (`:root {}`) for colors, spacing, and fonts.
- **Imports**: Import theme or color files at the top of `style.css`.

---

## 4. Naming Conventions

- **Classes**: Use `.module.<name>` for modules, `.custom-<name>` for custom modules.
    - Example: `.module.cpu`, `.custom-nowplaying`
- **States**: Use modifier classes for states (e.g., `.warning`, `.critical`).
    - Example: `.module.battery.critical`
- **No IDs**: Avoid `#id` selectors unless strictly necessary.

---

## 5. Color Scheme & Theming

- **Base Colors**: Define all colors as CSS variables.
- **Theming**: Use a theme file to override variables for different color schemes (e.g., light/dark).
- **Accent Colors**: Use a single accent color for highlights, with subtle variants for hover/focus states.
- **Colors**: Any colors should be imported from colors.css file or defined manually in style file.

**Example:**
```css
/* define color as */
@define-color background #1a1112;
```

---

## 6. Module Styling

### General Module Style

- **Padding**: Use consistent padding (e.g., `10px`).
- **Spacing**: Use margins for spacing modules (e.g., `margin: 2px 15px 2px 0;`).
- **Font**: Inherit the base font (e.g., `Fira Sans Semibold`) unless a specific module needs a different font. `(different fonts are allowed for custon themes)` 
- **Border and Radius**: Use of border is optional and rounding is arbitrary.

**Example:**
```css
#custom-appmenu {
    background-color: @background;
    font-size: 16px;
    color: @on_surface;
    border-radius: 5px 5px 5px 5px;
    padding: 0px 10px 0px 10px;
    margin: 2px 17px 2px 0px;
    border: 2px solid @border_color;
}
```

### State Styling

- **Hover**: Lighten/darken background.
- **Active/Focused**: Use primary color or brighter color for monochrome.
- **Warning/Critical**: Use warning/critical variables or custom colors.

**Example:**
```css
.module.battery.warning {
  color: @error1;
}
.module.battery.critical {
  color: @error2;
  font-weight: bold;
}
```

---

## 7. Responsive Design

- **Scaling**: Use `em` or `%` for scaling when needed otherwise use `px`.
- **Multi-monitor**: Ensure padding/margins work on both horizontal and vertical bars.

---

## 8. Custom Widgets

- **Class Naming**: All custom modules/scripts should have a unique `.custom-<name>` class.
- **Icons**: Use [Font Awesome](https://www.fontawesome.com/) or [Material Icons](https://www.fonts.google.com/) and SVGs for icons.
- **Animation**: Keep animations minimal and non-distracting.

---

## 9. Accessibility

- **Contrast**: Ensure text/background contrast ratio is at least 4.5:1.
- **Opacity**: Opacity for module should be between `0.5-0.8`.
- **Font Size**: Use at least 16px for readability.
- **Focus States**: Provide visible focus indicators for interactive modules.

---

## 10. Versioning and Comments

- **Header**: Add a header to your `style.css` describing the author, last update, and version.
- **Section Comments**: Use clear comments to separate and describe sections.

**Example:**
```css
/*
 * __        __          _                  ____  _         _
 * \ \      / /_ _ _   _| |__   __ _ _ __  / ___|| |_ _   _| | ___
 *  \ \ /\ / / _` | | | | '_ \ / _` | '__| \___ \| __| | | | |/ _ \
 *   \ V  V / (_| | |_| | |_) | (_| | |     ___) | |_| |_| | |  __/
 *    \_/\_/ \__,_|\__, |_.__/ \__,_|_|    |____/ \__|\__, |_|\___|
 *                 |___/                              |___/
 *
 * ----------------------------------------------------------------
*/
/* =====================================================
 * (Theme Name) - ML4W Dotfiles
 * Author: (name)
 * Last Updated: 2025-09-27
 * Version: 1.0
 * ===================================================== */
```

```css
/* -----------------------------------------------------
 * Workspaces
 * ----------------------------------------------------- */
```
---

**Happy theming!**  
*Keep your bar stylish, readable, and maintainable for everyone who uses ML4W dotfiles.*
