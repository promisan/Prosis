
<cfparam name="Attributes.Title"      default="Problem">
<cfparam name="Attributes.Message"    default="Problem">
<cfparam name="Attributes.Color"      default="">
<cfset client.message = Attributes.Message>



<cfoutput>


<script>

	ProsisUI.doAlert("#attributes.Title#","#attributes.Message#","#attributes.color#");

</script>

</cfoutput>