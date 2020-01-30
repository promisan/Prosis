<!--- Clear all access in deactivate missions --->

<cf_assignid>

<cftransaction>

<cfinvoke component="Service.Access.AccessLog"  
	  method="DeleteAccess"
	  ActionId             = "#rowguid#"
	  ActionStep           = "Clear Access Deactivate Mission"
	  ActionStatus         = "9"
	  UserAccount          = ""
	  Condition            = "Mission = '#url.mission#'"
	  ConditionGroup       = "Mission = '#url.mission#'">	 
	
</cftransaction>	