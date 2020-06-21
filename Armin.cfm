

<!--- for Armin --->

<cf_screentop jquery="Yes" height="100%" scroll="yes" html="Yes">

<cfoutput>--#client.googlemapid#-</cfoutput>
<cfajaximport tags="cfmap" params="#{googlemapkey='#client.googlemapid#'}#">

<input type="button" name="Kendo open" value="Kendor open" onclick="openkendo()">

<script>
function openkendo() {		
ProsisUI.createWindow('myparent', 'Parent Office', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,resizable:false,center:true})    						
}
	
</script>