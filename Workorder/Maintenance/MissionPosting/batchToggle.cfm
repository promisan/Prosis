<cfoutput>
		<img src="#SESSION.root#/images/wait.gif"  width="15" height="15 style="cursor: default;">
	<script>
		ColdFusion.navigate('#SESSION.root#/workorder/application/tools/PostFinancials.cfm?mission=#url.id2#&posting=1&serviceitem=#url.id1#&inlineexecution=1', 'iconBatchContainer_#url.id1#_#url.id2#');		
	</script>
</cfoutput>


