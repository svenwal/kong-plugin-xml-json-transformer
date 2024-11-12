# About
`````xml-json-transformer````` is a [Kong](https://konghq.com) plugin which converts a XML response into JSON.

Backend with GZip enabled need to add the Accept-Encoding:compress header for now
This can be done also using the request-transformer plugin

## Configuration parameters
|FORM PARAMETER|DEFAULT|DESCRIPTION|
|:----|:------:|------:|
|config.ignore_content_type|false|Note: not in 0.3 currently. This parameter can be used if any traffic (not only application/xml) shall be tried to convert|


## Examples

Example backend used here: http://www.inf.fu-berlin.de/lehre/SS03/19560-P/Docs/JWSDP/tutorial/examples/jaxp/sax/samples/slideSample01.xml


````
> http :8001/services/<SERVICE>/plugins name=xml-json-transformer 

HTTP/1.1 201 Created
(...)

{
    "config": {
        "config.ignore_content_type": false
    },
    "created_at": 1554887400000,
    "enabled": true,
    "id": "1a659088-2e38-4a9f-bfef-f84400c86f5a",
    "name": "xml-json-transformer",
    "service_id": "f42acc5b-4e85-4ec2-8638-c7dbdd84b8a9"
}
````
Response if plugin is ***not enabled***:
`````
> http :8000/xml2json

HTTP/1.1 200 OK
(...)
Content-Type: application/xml
(...)

<?xml version='1.0' encoding='us-ascii'?>

<!--  A SAMPLE set of slides  -->

<slideshow 
    title="Sample Slide Show"
    date="Date of publication"
    author="Yours Truly"
    >

    <!-- TITLE SLIDE -->
    <slide type="all">
      <title>Wake up to WonderWidgets!</title>
    </slide>

    <!-- OVERVIEW -->
    <slide type="all">
        <title>Overview</title>
        <item>Why <em>WonderWidgets</em> are great</item>
        <item/>
        <item>Who <em>buys</em> WonderWidgets</item>
    </slide>

</slideshow>
`````
Response if plugins is ***enabled***
`````
> http :8000/xml2json Accept-Encoding:compress

HTTP/1.1 200 OK
(...)
Content-Type: application/json
(...)

{
    "slideshow": {
        "_attr": {
            "author": "Yours Truly",
            "date": "Date of publication",
            "title": "Sample Slide Show"
        },
        "slide": [
            {
                "_attr": {
                    "type": "all"
                },
                "title": "Wake up to WonderWidgets!"
            },
            {
                "_attr": {
                    "type": "all"
                },
                "item": [
                    {
                        "1": "Why",
                        "2": "are great",
                        "em": "WonderWidgets"
                    },
                    {},
                    {
                        "1": "Who",
                        "2": "WonderWidgets",
                        "em": "buys"
                    }
                ],
                "title": "Overview"
            }
        ]
    }
}
`````
