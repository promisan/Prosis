<meta name="viewport" content="width=device-width, initial-scale=1.0">

<script>
    function getSignatureWidth() {
	
        let width = screen.width;
        if (width <= 480)
            document.getElementById("dCanvasMobile").style.display = "block";
        else
            document.getElementById("dCanvasDesktop").style.display = "block";
	        document.getElementById("bSign").style.display  = "none";
	        document.getElementById("bClear").style.display = "block";
	        document.getElementById("bDone").style.display  = "block";
    }

    function clearSignature() {
	
        let width = screen.width;
        if (width <= 480)
            surfaceMobile.clear();
        else
            surfaceDesktop.clear();
			
    }

    function saveSignature() {
	   
        let width = screen.width;
        if (width <= 480) {
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
        if (width <= 480) {
            _saveSVGMobile();
        } else {
            _saveSVGDesktop();
        }
    }

</script>

<cf_UISignatureScript Mode = "Desktop">
<cf_UISignatureScript Mode = "Mobile">

