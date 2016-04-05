#!/bin/bash -xe
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.


# fairy-slipper should be installed with test-requirements.txt
# Migrate DocBook and WADL files to Swagger JSON

function convert_to_swagger {
    if [ ! -d swagger ]; then
      mkdir swagger
    fi

    # Generate JSON
    find api-ref/src/docbkx/ -name api-ref-\* -type f -exec fairy-slipper-docbkx-to-json -o swagger {} \;

    # Generate Swagger
    find swagger -name api-ref\*json -type f -exec fairy-slipper-wadl-to-swagger-valid -o swagger {} \;

    # Remove interim JSON files
    rm -r swagger/api-ref*

}

function swagger_bootprint_html {
    # Copy in source files which are already in Swagger format
    cp api-ref/src/swagger/*.json swagger/

    # Generate HTML plus CSS for each Swagger file
      for i in swagger/*.json
        do
        service_dir=${i%.*}
        bootprint openapi $i $service_dir
      done
}

convert_to_swagger
swagger_bootprint_html
