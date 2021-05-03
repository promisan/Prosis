
<cfset wflnk = "../WorkFlow/WorkflowContent.cfm">
  
<cfoutput>   
     <input type="hidden" id="workflowlink_#url.workorderid#" name="workflowlink_#url.workorderid#" value="#wflnk#"> 
</cfoutput>	   
 
<cf_securediv id="#url.workorderid#"  bind="url:#wflnk#?ajaxid=#url.workorderid#"/>
