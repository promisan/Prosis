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
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<cfoutput>
<cfset vLimit = 485>
<script>
    function getSignatureWidth() {
	
        let width = screen.width;
        if (width <= #vLimit#)
            document.getElementById("dCanvasMobile").style.display = "block";
        else
            document.getElementById("dCanvasDesktop").style.display = "block";
	        document.getElementById("bSign").style.display  = "none";
	        document.getElementById("bClear").style.display = "block";
	        document.getElementById("bDone").style.display  = "block";
    }

    function clearSignature() {
        let width = screen.width;
        if (width <= #vLimit#)
        {
            document.getElementById("surfaceMobile").style.display = "block";
            document.getElementById("imageMobile").style.display = "none";
            surfaceMobile.clear();
        }
        else
        {
            document.getElementById("surfaceDesktop").style.display = "block";
            document.getElementById("imageDesktop").style.display = "none";
            surfaceDesktop.clear();
        }
			
    }

    function saveSignature() {
	   
        let width = screen.width;
        if (width <= #vLimit#) {
            _saveSVGMobile();
            document.getElementById("dCanvasMobile").style.display = "none";
        } else {
            _saveSVGDesktop();
            document.getElementById("dCanvasDesktop").style.display = "none";
        }
		try { document.getElementById("bSign").style.display  = "block"; } catch(e) {}
        try { document.getElementById("bClear").style.display = "none"; } catch(e) {}
        try { document.getElementById("bDone").style.display  = "none"; } catch(e) {}
				
    }

    function updateSignature() {
        let width = screen.width;
        if (width <= #vLimit#) {
            _saveSVGMobile();
        } else {
            _saveSVGDesktop();
        }
    }

</script>
</cfoutput>
<cf_UISignatureScript Mode = "Desktop">
<cf_UISignatureScript Mode = "Mobile">

