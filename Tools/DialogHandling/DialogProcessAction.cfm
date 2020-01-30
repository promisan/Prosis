
<cfoutput>

	<cfwindow 
	     name        = "dialogemployee"
	     title       = "Employee Search"
	     height      = "540"
	     width       = "600"
		 bodystyle   = "background-color:ffffff"
	 	 headerstyle = "background-color:ActiveCaption"
	     minheight   = "540"
	     minwidth    = "600"
	     center      = "True"
	     modal       = "True"/>
	 
	<script>	 
		 
	function selectemployee(table) {
	    ColdFusion.Window.show("employee")
		ColdFusion.navigate('#SESSION.root#/Staffing/Application/Employee/Lookup/LookupSearch.cfm?table=purchase.dbo.stJobReviewPanel','employee');			
	</script>	

</cfoutput> 