# flavors.lua
Simple flavor managment for projects. Supports Copying files and substituting
parts of files.

## Installation
Simply clone this Github repo or download the [latest release](https://github.com/sro5h/flavors.lua/releases/latest)
~~~
git clone https://github.com/sro5h/flavors.lua.git
~~~

## Getting started
To create a flavor of a project you need to create a directory containing all the files specific to that flavor and a `flavor.json`. This json file needs to contain a `project` element containing the path to the project and a `files` element containing all the files belonging to the flavor. Assuming you have got a project that needs to be distributed under two brandings, you can create two flavors and apply them as you need. All you need to do is create two directories e.g.
~~~
flavor1
    - icon.png
    - flavor.json
~~~
~~~
flavor2
    - icon.png
    - flavor.json
~~~
... and setup the `flavor.json` files as follows
~~~ json
{
    "project" : "path/to/project",
    "files" : [
        {
            "src" : "icon.png"
        }
    ]
}
~~~
Now you can run `lua flavor.lua [flavor1|flavor2]` to apply one of the flavors.

## Advanced

### Copying
If you followed the Getting started guide, you could see that the path specified in the `src` element is both relative to the *project* and *flavor* directory. To copy the file to a different destination use the `dest` element
~~~ json
{
    "project" : "path/to/project",
    "files" : [
        {
            "src" : "icon.png",
            "dest" : "res/icon.png"
        }
    ]
}
~~~
The `dest` element also accepts an array of paths to allow copying one file to different locations. E.g. `"dest" : [ "res/icon.png", "res2/icon.png" ]`.
In some cases, e.g. android development, you have different versions of a file with the same name in different subdirectories, therefor both `dest` *and* `src` accept arrays of paths. Note though that files will be matched 1:1 in the order you write them and redundant files will be omitted. E.g.
~~~ json
{
    "project" : "path/to/project",
    "files" : [
        {
            "src" : [
                "res/drawable-mdpi/icon.png",
                "res/drawable-hdpi/icon.png"
            ],
            "dest" : [
                "res/drawable-mdpi/icon.png",
                "res/drawable-hdpi/icon.png",
                "res/drawable-xdpi/icon.png"
            ]
        }
    ]
}
~~~
Assuming the file above, the `drawable-mdpi` and `drawable-hdpi` directories will be matched and the `drawable-xdpi` directory in `dest` will be ignored because it has no matching `src` directory.

### Substitution
You can also substitute strings in files using [lua patterns](https://www.lua.org/pil/20.2.html). To perform such a substitution you need to add an object to the `files` array that has a `src` element and an array `subs` that defines the substitutions to perform. E.g.
~~~ json
{
    "project" : "path/to/project",
    "files" : [
        {
            "src" : "res/values/strings.xml",
            "subs" : [
                {
                    "replace" : "(<string name=\"app_name\">).-(</string>)",
                    "with" : "<string name=\"app_name\">Flavor1</string>"
                }
            ]
        }
    ]
}
~~~
Note that `src` can also be an array of paths to allow performing the same substitution on multiple files.  
Now you should have a general understanding of how to create flavors with `flavors.lua` and apply them to your projects.
