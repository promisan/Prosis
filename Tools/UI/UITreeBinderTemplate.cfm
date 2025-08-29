<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<!---
https://docs.telerik.com/kendo-ui/framework/templates/overview
Kendo UI Templates use a simple templating syntax we call "hash templates."
With this syntax, the "#" (or hash) symbol is used to mark areas in a template
that should be replaced with data when the template is executed.

There are three ways to use the hash syntax:

    Render literal values: #= #
    Render HTML-encoded values: #: #
    Execute arbitrary JavaScript code: # if(...){# ... #}#
--->
    <script type="text/x-kendo-template" id="_prosis-tree-template">
        #
        var vSize = 12;
        switch(item.level()) {
        case 0:
            vSize = 17;
            break;
        case 1:
            vSize = 15;
            break;
        case 2:
            vSize = 14;
            break;
        }

        vImage = false;
        if (item.IMG)
        {
            if (item.IMG != '')
            {
                vImage = true;
            }
        }
        if (vImage) { #
            <img src='#=item.IMG#' style='width:18px;height:auto;border:0px;top:0;padding-right:3px'>
            <div style='font-size:#=vSize#px;font-family:Helvetica;line-height: 18px;'>#=item.DISPLAY#</div>
        # }
        else
        { #
            <div style='font-size:#=vSize#px;font-family:Helvetica;line-height: 18px;'>#=item.DISPLAY#</div>
        # } #
    </script>
