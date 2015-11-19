godoc2dash
==========

This is a quick hack to convert `godoc`'s for packages and convert them into a format for Dash to consume.


## Usage:

Convert your Golang project docs into Dash-compatible docsets! All in 3-simple steps!

### Step 1: Create icon.png

Make an `icon.png` in the repo's root, which should be adjacent to this `README`. This script will automatically convert the icon to 32x32px for use within Dash.

### Step 2: Update your Configuration

Open `Config.mk` in your favorite text-editor. Be sure to update both `DOCSET_SOURCE` which should point to your qualified package name (including github.com or other domain) and `DOCSET_TARGET` which is the name of your DocSet.

### Step 3: Run

Next, simply run `make` and your code documentation will be converted to a docset and added to Dash automatically.

## Notes

`docs.css` is the default godoc css. You can update it how you like.

## Credits

Twitter: [Mike Mackintosh](https://twitter.com/mikemackintosh)
GitHub: [Mike Mackintosh](https://github.com/mikemackintosh)
