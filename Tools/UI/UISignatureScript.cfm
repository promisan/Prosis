<!--
    Copyright © 2025 Promisan

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
<cfparam name="Attributes.FormName"  default="_fSignature">
<cfparam name="Attributes.Mode"      default="Desktop">

<cfoutput>

    <script>
	
        var geom#Attributes.Mode# = kendo.geometry;
        var Point#Attributes.Mode# = geom#Attributes.Mode#.Point;
        var draw#Attributes.Mode# = kendo.drawing;
        var Path#Attributes.Mode# = draw#Attributes.Mode#.Path;
        var path#Attributes.Mode#;
        var surface#Attributes.Mode#;

        <cfif Attributes.Mode eq "Desktop">
            <cfset vListener     = "mousemove">
            <cfset vListenerDown = "mousedown">
            <cfset vListenerUp   = "mouseup">
        <cfelse>
            <cfset vListener     = "touchmove">
            <cfset vListenerDown = "touchstart">
            <cfset vListenerUp   = "touchend">
        </cfif>

        function _saveSVG#Attributes.Mode#() {

            kendo.drawing.drawDOM($("##surface#Attributes.Mode#"))
                .then(function (group) {
                    // Render the result as a SVG document
                    return kendo.drawing.exportSVG(group);
                })
                .done(function (data) {
                    // Save the SVG document
                    document.getElementById("SignatureContent").value = data;
                    //ColdFusion.navigate('saveSignature.cfm','dSave',null,null,'POST','#Attributes.FormName#');
                });
        }

        function initSignatureCanvas#Attributes.Mode#() {
            $("##surface-container#Attributes.Mode#").on("#vListener#", function(e) {
                <cfif Attributes.Mode neq "Desktop">
                    e.preventDefault();
                </cfif>
                if (!path#Attributes.Mode#) {
                    return;
                }

                var offset = $(this).offset();
                <cfif Attributes.Mode eq "Desktop">
                    var newPoint = new Point#Attributes.Mode#(e.pageX - offset.left, e.pageY - offset.top);
                <cfelse>
                    var pageX = e.originalEvent.touches[0].pageX;
                    var pageY = e.originalEvent.touches[0].pageY;
                    var newPoint = new Point#Attributes.Mode#(pageX - offset.left, pageY - offset.top);
                </cfif>

                path#Attributes.Mode#.lineTo(newPoint);

            }).on("#vListenerDown#", function(e) {
                path#Attributes.Mode# = new Path#Attributes.Mode#({
                    stroke: {
                        color: '##1437E4',
                        width: 2,
                        lineCap: "round",
                        lineJoin: "round"
                    }
                });

                var offset = $(this).offset();
                <cfif Attributes.Mode eq "Desktop">
                    var newPoint = new Point#Attributes.Mode#(e.pageX - offset.left, e.pageY - offset.top);
                <cfelse>
                    var pageX = e.originalEvent.touches[0].pageX;
                    var pageY = e.originalEvent.touches[0].pageY;
                    var newPoint = new Point#Attributes.Mode#(pageX - offset.left, pageY - offset.top);
                </cfif>

                for (var i = 0; i < 1; i++) {
                    path#Attributes.Mode#.lineTo(newPoint.clone().translate(i * 1, 0));
                }

                surface#Attributes.Mode#.draw(path#Attributes.Mode#);

            }).on("#vListenerUp#", function(e) {
                path#Attributes.Mode# = undefined;
                updateSignature();
            });

            surface#Attributes.Mode# = draw#Attributes.Mode#.Surface.create($("##surface#Attributes.Mode#"));
        }

    </script>

    </cfoutput>
