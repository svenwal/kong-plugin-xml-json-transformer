# About
`````xml-json-transformer````` is a [Kong](https://konghq.com) plugin which adds a random latency and/or random errors to responses in order to simulate bad networks.

## Configuration parameters
|FORM PARAMETER|DEFAULT|DESCRIPTION|
|:----|:------:|------:|
|config.minimum_latency_msec|0|This parameter describes the minimum latency (msec) to be added|
|config.maximum_latency_msec|1000|This parameter describes the maximum latency (msec) to be added|
|config.percentage_latency|50|Percentage of requests which shall get the latency added|
|config.percentage_error|0|Percentage of requests which shall return an error|
|config.status_codes|500|Array of http status codes which will be used if error is returned (random selection from array)|
|config.add_header|true|If set to true a header X-Kong-Latency-Injected will be added with either the value of the added latency or none if random generator has chosen not to add a latency. Also adds the X-Kong-Error-Injected header if http status code has been added.|

## Examples
````
> http :8001/services/<SERVICE>/plugins name=xml-json-transformer 

HTTP/1.1 201 Created
(...)

{
    "config": {
        "add_header": true,
        "maximum_latency_msec": 1000,
        "minimum_latency_msec": 0,
        "percentage_error": 0,
        "percentage_latency": 50
    },
    "created_at": 1554887400000,
    "enabled": true,
    "id": "1a659088-2e38-4a9f-bfef-f84400c86f5a",
    "name": "xml-json-transformer",
    "route_id": "f42acc5b-4e85-4ec2-8638-c7dbdd84b8a9"
}
````
Response if random generator has decided to add latency:
`````
> http :8000/latency

HTTP/1.1 200 OK
(...)
X-Kong-Proxy-Latency: 90
X-Kong-Latency-Injected:: 89
X-Kong-Upstream-Latency: 227

(BODY OF RESPONSE)
`````
Response if random generator decided not to add latency (see "none" in header)
`````
> http :8000/latency

HTTP/1.1 200 OK
(...)
X-Kong-Proxy-Latency: 1
X-Kong-Latency-Injected:: none
X-Kong-Upstream-Latency: 213

(BODY OF RESPONSE)
`````
Response with both latency and status code (400) injected (headers activated)
`````
HTTP/1.1 400 Bad Request
Connection: close
(...)
X-Kong-Error-Injected: 400
X-Kong-Latency-Injected: 276

Bad request
`````