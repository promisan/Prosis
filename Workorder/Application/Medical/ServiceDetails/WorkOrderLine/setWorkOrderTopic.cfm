
<!--- save custom fields on the level of the line --->

<cfset id = url.workorderid>

<cfinclude template="../../../WorkOrder/Create/CustomFieldsSubmit.cfm">

<cfoutput>

   <input type="button" 
      style="font-size:15px;width:320;height:30px" 
	  name="close" 
	  value="Save" 
	  class="button10g" 
      onclick="Prosis.busy('yes');updateTextArea();ptoken.navigate('#session.root#/workorder/Application/Medical/ServiceDetails/WorkOrderLine/setWorkOrderTopic.cfm?topicclass=request&workorderid=#url.workorderid#&workorderline=#url.workorderline#&domainclass=#url.domainclass#','custom','','','POST','customform')">
	
</cfoutput>

<script>
	Prosis.busy('no')
</script>