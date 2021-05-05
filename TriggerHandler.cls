public abstract class TriggerHandler {
    @TestVisible
    private System.TriggerOperation operationType;
    
    public TriggerHandler() {
        this.operationType = Trigger.operationType;
    }
    
    public void run() {
        if(isDisable()) {
            debugTriggerDisable();
            return;
        }
        
        switch on operationType {
            when BEFORE_INSERT {
                this.beforeInsert(getTriggerNew());
                this.beforeInsert();
            }
            when BEFORE_UPDATE {
                this.beforeUpdate(getTriggerMapNew(), getTriggerMapOld());
                this.beforeUpdate();
            }
            when BEFORE_DELETE {
                this.beforeDelete(getTriggerMapOld());
                this.beforeDelete();
            }
            when AFTER_INSERT {
                this.afterInsert(getTriggerMapNew());
                this.afterInsert();
            }
            when AFTER_UPDATE {
                this.afterUpdate(getTriggerMapNew(), getTriggerMapOld());
                this.afterUpdate();
            }
            when AFTER_DELETE {
                this.afterDelete(getTriggerMapOld());
                this.afterDelete();
            }
            when AFTER_UNDELETE {
                this.afterUndelete(getTriggerMapNew());
                this.afterUndelete();
            }
        }
    }
    
    public void runByRecordtype(String recordTypeDeveloperName) {
        if(isDisable()) {
            debugTriggerDisable();
            return;
        }
        
        switch on operationType {
            when BEFORE_INSERT {
                this.beforeInsert(getTriggerNewByRecordTypeDeveloperName(recordTypeDeveloperName));
            }
            when BEFORE_UPDATE {
                this.beforeUpdate(getTriggerNewMapByRecordTypeDeveloperName(recordTypeDeveloperName), 
                                  getTriggerOldMapByRecordTypeDeveloperName(recordTypeDeveloperName));
            }
            when BEFORE_DELETE {
                this.beforeDelete(getTriggerOldMapByRecordTypeDeveloperName(recordTypeDeveloperName));
            }
            when AFTER_INSERT {
                this.afterInsert(getTriggerNewMapByRecordTypeDeveloperName(recordTypeDeveloperName));
            }
            when AFTER_UPDATE {
                this.afterUpdate(getTriggerNewMapByRecordTypeDeveloperName(recordTypeDeveloperName), 
                                 getTriggerOldMapByRecordTypeDeveloperName(recordTypeDeveloperName));
            }
            when AFTER_DELETE {
                this.afterDelete(getTriggerOldMapByRecordTypeDeveloperName(recordTypeDeveloperName));
            }
            when AFTER_UNDELETE {
                this.afterUndelete(getTriggerNewMapByRecordTypeDeveloperName(recordTypeDeveloperName));
            }
        }
    }
        
    protected virtual void beforeInsert(List<SObject> listNew) {
        System.debug(LoggingLevel.FINEST, 'Abstract Trigger Handler, Before Insert Context');
    }
    
    protected virtual void beforeInsert() {
        System.debug(LoggingLevel.FINEST, 'Abstract Trigger Handler, Before Insert Context, without params');
    }
    
    protected virtual void beforeUpdate(Map<Id, SObject> mapNew, Map<Id, SObject> mapOld) {
        System.debug(LoggingLevel.FINEST, 'Abstract Trigger Handler, Before Update Context');
    }
    
    protected virtual void beforeUpdate() {
        System.debug(LoggingLevel.FINEST, 'Abstract Trigger Handler, Before Update Context, without params');
    }
    
    protected virtual void beforeDelete(Map<Id, SObject> mapOld) {
        System.debug(LoggingLevel.FINEST, 'Abstract Trigger Handler, Before Delete Context');
    }
    
    protected virtual void beforeDelete() {
        System.debug(LoggingLevel.FINEST, 'Abstract Trigger Handler, Before Delete Context, without params');
    }
    
    protected virtual void afterInsert(Map<Id, SObject> mapNew) {
        System.debug(LoggingLevel.FINEST, 'Abstract Trigger Handler, After Insert Context');
    }
    
    protected virtual void afterInsert() {
        System.debug(LoggingLevel.FINEST, 'Abstract Trigger Handler, After Insert Context, without params');
    }
    
    protected virtual void afterUpdate(Map<Id, SObject> mapNew, Map<Id, SObject> mapOld) {
        System.debug(LoggingLevel.FINEST, 'Abstract Trigger Handler, After Update Context');
    }
    
    protected virtual void afterUpdate() {
        System.debug(LoggingLevel.FINEST, 'Abstract Trigger Handler, After Update Context, without params');
    }
    
    protected virtual void afterDelete(Map<Id, SObject> mapOld) {
        System.debug(LoggingLevel.FINEST, 'Abstract Trigger Handler, After Delete Context');
    }
    
    protected virtual void afterDelete() {
        System.debug(LoggingLevel.FINEST, 'Abstract Trigger Handler, After Delete Context, without params');
    }
    
    protected virtual void afterUndelete(Map<Id, SObject> mapNew) {
        System.debug(LoggingLevel.FINEST, 'Abstract Trigger Handler, After Undelete Context');
    }
    
    protected virtual void afterUndelete() {
        System.debug(LoggingLevel.FINEST, 'Abstract Trigger Handler, After Undelete Context, without params');
    }
        
    protected List<SObject> getTriggerNew() {
        if(Trigger.new == null) {
            return new List<SObject>();
        }
        return Trigger.new;
    }
        
    protected List<SObject> getTriggerOld() {
        if(Trigger.old == null) {
            return new List<SObject>();
        }
        return Trigger.old;
    }
    
    protected Map<Id, SObject> getTriggerMapNew() {
        if(Trigger.newMap == null) {
            return newMap();
        }
        return Trigger.newMap;
    }
    
    protected Map<Id, SObject> getTriggerMapOld() {
        if(Trigger.oldMap == null) {
            return newMap();
        }
        return Trigger.oldMap;
    }
        
    protected List<SObject> getTriggerNewByRecordTypeDeveloperName(String recordTypeDeveloperName) {
        return getListByRecordTypeDeveloperName(getTriggerNew(), recordTypeDeveloperName);
    }
    
    protected List<SObject> getTriggerOldByRecordTypeDeveloperName(String recordTypeDeveloperName) {
        return getListByRecordTypeDeveloperName(getTriggerOld(), recordTypeDeveloperName);
    }
    
    private List<SObject> getListByRecordTypeDeveloperName(List<SObject> listObjects, String recordTypeDeveloperName) {
        Id recordTypeId = getRecordTypeIdByDeveloperName(recordTypeDeveloperName);
        
        List<SObject> listSeparetedObjects = new List<SObject>();
        for(SObject varSobject : listObjects) {
            if(recordTypeId.equals((Id) varSobject.get('RecordTypeId'))) {
                listSeparetedObjects.add(varSobject);
            }
        }
        
        return listSeparetedObjects;
    }
    
    private Id getRecordTypeIdByDeveloperName(String recordTypeDeveloperName) {
        if(Trigger.new == null && Trigger.old == null) {
            return null;
        }
        
        SObject varSobject = getSObject();
        
        if(!varSobject.getSObjectType().getDescribe().getRecordTypeInfosByDeveloperName().containsKey(recordTypeDeveloperName)) {
            throw new TriggerHandlerException('record type [' +recordTypeDeveloperName+ '] not found on sobject [' + varSobject.getSObjectType().getDescribe().getName() + ']');
        }
        
        return varSobject.getSObjectType().getDescribe().getRecordTypeInfosByDeveloperName().get(recordTypeDeveloperName).getRecordTypeId();
    }
    
    private SObject getSObject() {
        if(Trigger.new != null) {
            return Trigger.new.get(0);
        } else if(Trigger.old != null) {
            return Trigger.old.get(0);
        } else {
            throw new TriggerHandlerException('Trigger.new and Trigger.old is null');
        }
    }
    
    protected Map<Id, SObject> getTriggerNewMapByRecordTypeDeveloperName(String recordTypeDeveloperName) {
        List<SObject> listObjects = getListByRecordTypeDeveloperName(getTriggerNew(), recordTypeDeveloperName);
        return buildMapByRecordTypeDeveloperName(listObjects);
    }
    
    protected Map<Id, SObject> getTriggerOldMapByRecordTypeDeveloperName(String recordTypeDeveloperName) {
        List<SObject> listObjects = getListByRecordTypeDeveloperName(getTriggerOld(), recordTypeDeveloperName);
        return buildMapByRecordTypeDeveloperName(listObjects);
    }
    
    protected Map<Id, SObject> buildMapByRecordTypeDeveloperName(List<SObject> listObjects) {
        Map<Id, SObject> mapObjects = newMap();
        if(listObjects == null) {
            return mapObjects;
        }
        
        for(SObject varSObject : listObjects) {
            if(!String.isBlank(varSObject.Id)) {
                mapObjects.put(varSObject.Id, varSObject);
            }
        }
        
        return mapObjects;
    }
    
    private Map<Id, SObject> newMap() {
        Map<Id, SObject> mapSObject;
        if(Trigger.newMap != null) {
            mapSObject = Trigger.newMap.clone();
        } else if(Trigger.oldMap != null) {
            mapSObject = Trigger.oldMap.clone();
        } else {
            return null;
        }
        mapSObject.clear();
        return mapSObject;
    }
    
    private Boolean isDisable() {
        return FeatureManagement.checkPermission(getCurrentClassName() + 'Disable');
    }
    
    private String getCurrentClassName() {
        return String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
    }
    
    private void debugTriggerDisable() {
        String currentClassName = getCurrentClassName();
        String customPermissionName = currentClassName + 'Disable';
        String userName = System.UserInfo.getUserName();
        System.debug(system.LoggingLevel.INFO, 'The '+currentClassName+' Trigger is disabled for the '+userName+' user because he has the '+customPermissionName+' custom permission');
    }
    
    public class TriggerHandlerException extends Exception { }
}
