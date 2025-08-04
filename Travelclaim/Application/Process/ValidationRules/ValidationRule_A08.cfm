<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfsilent>
<proUsr>Joseph George</proUsr>
  <proOwn>Joseph George</proOwn>
 <proDes>Template for validation Rule A08  </proDes>
 <proCom>New File For Validation A08 </proCom>
</cfsilent>

<!--- 
						Validation Rule :  A08
						Name			:  Incorporated in A04 
						                   The logic is simple Check for REquireRequestLine = True or 1
										   Based against the Check of all the claims ,and then loop it 
										   with individual claimcategory and find whether the 
										   claimcategory in question are Ref_claimcategory.
											
											
						Steps			:  Check Claim categorys and loop it within Ref_claimCategory table 
						                   and find out whether RequireRequestLine is set to be true or not.
										   
						Date			:  18 Sep 2007
						Last date		:  18 Sep 2007
--->

