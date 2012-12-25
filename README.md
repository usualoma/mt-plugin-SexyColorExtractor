# SexyColorExtractor

This plugin enables the Movable Type to extract sexy colors from images.


## Features

* Extract sexy colors.
* Output color values.
  * RGB
  * HSV


### Output sample

![Screenshot](https://github.com/usualoma/mt-plugin-SexyColorExtractor/raw/master/artwork/output-sample.png)


### Example template

```html
<mt:SetVarTemplate name="gradient_top_bottom">
background: -webkit-linear-gradient(top, <mt:Var name="gradient_values" />);
background: -moz-linear-gradient(top, <mt:Var name="gradient_values" />);
background: -o-linear-gradient(top, <mt:Var name="gradient_values" />);
background: -ms-linear-gradient(top, <mt:Var name="gradient_values" />);
background: linear-gradient(to bottom, <mt:Var name="gradient_values" />);
</mt:SetVarTemplate>
<mt:SetVarTemplate name="gradient_left_right">
background: -webkit-linear-gradient(left, <mt:Var name="gradient_values" />);
background: -moz-linear-gradient(left, <mt:Var name="gradient_values" />);
background: -o-linear-gradient(left, <mt:Var name="gradient_values" />);
background: -ms-linear-gradient(left, <mt:Var name="gradient_values" />);
background: linear-gradient(to right, <mt:Var name="gradient_values" />);
</mt:SetVarTemplate>

<mt:Assets>
<div style="color: <mt:AssetSexyTextMainColor />; text-shadow: 0 1px 0 <mt:If tag="AssetSexyTextMainColor" map="HSV" format="%3$d" lt="128">rgba(255,255,255,0.4)<mt:Else>rgba(0,0,0,0.4)</mt:If>; background-color: <mt:AssetSexyBackgroundColor />; float: left; width: 100%;">
<div style="font-weight: bold; font-size: 120%; padding: 10px;"><mt:AssetLabel /></div>
<div style="color: <mt:AssetSexyTextSubColor />; text-shadow: 0 1px 0 <mt:If tag="AssetSexyTextSubColor" map="HSV" format="%3$d" lt="128">rgba(255,255,255,0.4)<mt:Else>rgba(0,0,0,0.4)</mt:If>; width: 500px; padding: 10px; float: left">
<mt:AssetDescription />
</div>

<div style="position: relative; height: 200px; width: 200px; float: left;">
<mt:SetVarBlock name="gradient_values"><mt:AssetSexyBackgroundColor /> 0%, rgba(<mt:AssetSexyBackgroundColor format="%d, %d, %d" />, 0.25) 20%</mt:SetVarBlock>
<img src="<mt:AssetThumbnailURL width="200" square="1" />" style="position: absolute; right: 0px; top: 0px; z-index: 1;" />
<div style="position: absolute; right: 0px; top: 0px; z-index: 2; width: 200px; height: 200px; <mt:Var name="gradient_top_bottom" />"></div>
<div style="position: absolute; right: 0px; top: 0px; z-index: 3; width: 200px; height: 200px; <mt:Var name="gradient_left_right" />"></div>
</div>

</div>
</mt:Assets>
```


## Tags

* AssetSexyBackgroundColor
* AssetSexyTextMainColor
* AssetSexyTextSubColor

### Modifiers

* map="RGB | HSV" (default: "RGB")
* format="output-format" (default: "rgb(%d, %d, %d)")


## Supported publishing methods

* Static publishing
* Dynamic publishing (for images uploaded after this plug-in will be installed)
  * In dynamic publishing, we should escape if "$" is used. (e.g. format="%3\$d")


## Requirements

* Movable Type 5 or any later version
  * tested only under MT5.2.
* ImageMagick
  * A "ImageDriver" config directive should be "ImageMagick" that is default value.


## Installation

1. Unpack the `SexyColorExtractor` archive.
2. Upload the contents to the MT `plugins` directory.

Should look like this when installed:

    $MT_HOME/
        plugins/
            SexyColorExtractor/


## Reference

* [iTunes11のアルバム情報表示に使われるオシャレアルゴリズムを考える | fladdict](http://fladdict.net/blog/2012/11/itunes11_colorpicker.html)
* [オシャレアルゴリズム - jsdo.it - share JavaScript, HTML5 and CSS](http://jsdo.it/blogparts/cOMP)


## LICENSE

Copyright (c) 2012 ToI Inc.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

### Except `plugins/SexyColorExtractor/extlib/Color/Object.pm`
* [Color::Object](http://search.cpan.org/~areibens/Color-Object/)
