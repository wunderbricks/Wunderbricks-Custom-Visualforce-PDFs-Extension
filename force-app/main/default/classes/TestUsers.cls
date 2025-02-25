public with sharing class TestUsers {
    public static User wbCommercialUser {
        get {
            if (wbCommercialUser == null) {
                wbCommercialUser = [SELECT Id FROM User WHERE Username = 'wbuser@wb.com.username'];
            }
            return wbCommercialUser;
        }
        set;
    }

    public static User wbErpUser {
        get {
            if (wbErpUser == null) {
                wbErpUser = [SELECT Id FROM User WHERE Username = 'wbuser@wb.com.usernameeprintegration'];
            }
            return wbErpUser;
        }
        set;
    }

    public static User noPermissionUser {
        get {
            if (noPermissionUser == null) {
                noPermissionUser = [SELECT Id FROM User WHERE Username = 'wbuser@wb.com.usernamenoperm'];
            }
            return noPermissionUser;
        }
        set;
    }

    public static void setupTestUsers() {
        List<User> usersToInsert = new List<User>();
        List<PermissionSetAssignment> permSetAssignmentsToInsert = new List<PermissionSetAssignment>();

        
        Profile standardProfile;
        Profile systemAdminProfile;
        Profile integrationUserProfile;
        for (Profile prof : [SELECT Id, Name FROM Profile WHERE Name = 'Standard User' OR Name = 'System Administrator' OR Name = 'Salesforce API Only System Integrations' OR Name = 'Minimum Access - API Only Integrations']) {
            if (prof.Name == 'Standard User') {
                standardProfile = prof;
            } else if (prof.Name == 'System Administrator') {
                systemAdminProfile = prof;
            } else if (prof.Name == 'Salesforce API Only System Integrations' || prof.Name == 'Minimum Access - API Only Integrations') {
                integrationUserProfile = prof;
            }
        }

        wbCommercialUser      = createUser(
                'Wunderbricks',
                'User',
                'WBUser',
                'wbuser@wb.com',
                'wbuser@wb.com.username',
                'wbu',
                null,
                standardProfile.Id
        );
        usersToInsert.add(wbCommercialUser);

        noPermissionUser = createUser(
                'Wunderbricks',
                'UserNoPerm',
                'WBUsernp',
                'wbuser@wb.com',
                'wbuser@wb.com.usernamenoperm',
                'wbunp',
                null,
                standardProfile.Id
        );
        usersToInsert.add(noPermissionUser);

        wbErpUser = createUser(
            'Wunderbricks',
            'ERPUser',
            'WBErp',
            'wbuser@wb.com',
            'wbuser@wb.com.usernameeprintegration',
            'wbuerp',
            null,
            standardProfile.Id
        );
        usersToInsert.add(wbErpUser);

        insert usersToInsert;

        PermissionSet wbCommercialPermSet;
        PermissionSet wbStandardTsoPermSet;
        PermissionSet wunderbricksAdminPermSet;
        PermissionSet wbSpaceflowPermSet;
        PermissionSet wbErpPermSet;
        PermissionSet wbBagPermSet;

        for (PermissionSet permSet : [SELECT Id, Name FROM PermissionSet]) {
            if (permSet.Name == 'Wunderbricks_Commercial_Manager') {
                wbCommercialPermSet = permSet;
            } else if (permSet.Name == 'Wunderbricks_Standard_User_System_and_App') {
                wbStandardTsoPermSet = permSet;
            } else if (permSet.Name == 'Wunderbricks_Admin') {
                wunderbricksAdminPermSet = permSet;
            } else if (permSet.Name == 'Wunderbricks_Spaceflow_Integration') {
                wbSpaceflowPermSet = permSet;
            } else if (permSet.Name == 'Wunderbricks_ERP_Integration') {
                wbErpPermSet = permSet;
            } else if (permSet.Name == 'Wunderbricks_BAG_Permissions') {
                wbBagPermSet = permSet;
            }
        }

        permSetAssignmentsToInsert.add(createPermissionSetAssignment(wbCommercialPermSet.Id, wbCommercialUser.Id));
        if (wbStandardTsoPermSet != null) {
            permSetAssignmentsToInsert.add(createPermissionSetAssignment(wbStandardTsoPermSet.Id, wbCommercialUser.Id));
        }

        permSetAssignmentsToInsert.add(createPermissionSetAssignment(wbCommercialPermSet.Id, wbErpUser.Id));
        permSetAssignmentsToInsert.add(createPermissionSetAssignment(wbErpPermSet.Id, wbErpUser.Id));

        if (wbBagPermSet != null) {
            permSetAssignmentsToInsert.add(createPermissionSetAssignment(wbBagPermSet.Id, wbCommercialUser.Id));
            permSetAssignmentsToInsert.add(createPermissionSetAssignment(wbBagPermSet.Id, wbErpUser.Id));
        }

        // these are likely to get duplicate errors on real orgs, but we need it for when they are not assigned as async code runs in the running user's context in tests
        permSetAssignmentsToInsert.add(createPermissionSetAssignment(wbCommercialPermSet.Id, UserInfo.getUserId()));
        permSetAssignmentsToInsert.add(createPermissionSetAssignment(wunderbricksAdminPermSet.Id, UserInfo.getUserId()));

        Database.insert(permSetAssignmentsToInsert, false);
    }

    public static User createUser(String firstName, String lastName, String alias, String email, String username, String nickname, String userRoleId, String profileId) {
        return new User(
                FirstName         = firstName,
                LastName          = lastName,
                Alias             = alias,
                Email             = email,
                Username          = username,
                CommunityNickname = nickname,
                UserRoleId        = userRoleId,
                ProfileId         = profileId,
                LanguageLocaleKey = 'en_US',
                TimeZoneSidKey    = 'Europe/Amsterdam',
                EmailEncodingKey  = 'UTF-8',
                LocaleSidKey      = 'nl_NL'
        );
    }

    public static PermissionSetAssignment createPermissionSetAssignment(String permSetId, String userId){
        return new PermissionSetAssignment(PermissionSetId = permSetId, AssigneeId = userId);
    }
}