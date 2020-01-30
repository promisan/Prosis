
<html>
<head>
<cfoutput>
<title><cf_tl id="Workforce Table"> #URL.Mission#</title> 
</head>

<cfparam name="URL.Mission" default="">

<cfif URL.Mission eq "">
  <cf_message message = "I am not able to identify the tree/mission. Please consult your administrator" return = "">
</cfif> 
	
<script>
   window.location = "#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
</script>	
	
</cfoutput>

</html>