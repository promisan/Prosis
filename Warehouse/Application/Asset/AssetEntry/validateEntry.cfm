
<!--- validate barcode or decalno --->

<cfparam name="url.box"     default="BarCode_0001_001">
<cfparam name="url.field"   default="AssetBarcode">
<cfparam name="url.value"   default="">
<cfparam name="url.mission" default="">

 <cfquery name="getValue" 
    datasource="appsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT    *
    FROM      AssetItem
	WHERE     #url.field# = '#url.value#'
	AND       Mission = '#url.mission#'		
 </cfquery>
 
 <cfoutput>
 
	 <cfif getValue.recordcount gte "1">
	 
	 	<script>			   
		   document.getElementById('#url.box#').className = "wrong"
		   alert("You entered a #url.field# which already exists.")
		</script>
	 
	 <cfelse>
	 
	 	<script>	
		   document.getElementById('#url.box#').className = "regularxl"
		</script>
	 	
	 </cfif>
 
 </cfoutput>



