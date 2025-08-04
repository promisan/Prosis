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
<html>
<head>
<title>PHP List</title>

<!--- wrapper to display PHP_FULL as a CFDocument  --->

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<cfparam name="PHP_Roster_List" default="234567">

<cfloop Index="PHPPersonNo" List="#PHP_Roster_list#">

	<cfinclude template="PHP.cfm">

</cfloop>

</body>
</html>
