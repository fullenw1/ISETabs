# ISETabs

This module allows the user to act interactivelly on several ISE tabs.
It is primarly intended to be used with remote PSSession tabs.
Unlike jobs, you can proceed step by step and watch the result in each tab.

- New-ISERemoteTab creates collection of remote PSSessions tabs from a list of computers.
- Invoke-ISERemoteTab executes a scriptblock on a list of tabs.
- Remove-ISERemoteTab removes one or several tabs from the list.
- Add-ISERemoteTab adds remote PSSessions tabs to the list.