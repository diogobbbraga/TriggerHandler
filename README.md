
# Design partners - Trigger Handler Apex

Olá desenvolvedores Salesforce! Eu sei que já existem diversas implementações do padrão trigger handler em Apex, porém eu acredito que ainda temos margem para solucionar cenários específicos.

# Problema

 A Salesforce permite que você crie N Apex Triggers para um mesmo sObject, porém a própria documentação da Salesforce instrui que criar mais de um Apex Trigger por sObject não é uma boa prática, pois a sequência de execução não é definida e isso pode causar comportamentos imprevisíveis.

O PMD é um analisador estático de código que vem com muita força no mercado de desenvolvimento Salesforce e ele tem uma regra ainda mais restritiva, onde ele coloca que escrever regras de negócio em Apex Triggers é uma violação de criticidade média (AvoidLogicInTrigger).

As Apex Triggers tem como características acionamentos descontextualizados o que pode causar execução de instruções fora do momento adequado, caso as devidas tratativas não sejam tomadas.

  

## Implementações existentes
Consegui encontrar boas soluções propostas para os mais diversos cenários, umas de implementação mais complexas e outras menos, porém vale sempre conhecer.
- https://github.com/kevinohara80/sfdc-trigger-framework
- https://github.com/apexfarm/ApexTriggerHandler
- https://github.com/benedwards44/Apex-Trigger-Handler
- https://developer.salesforce.com/forums/?id=906F000000093cKIAQ

## Particularidade a implementação
O objetivo dessa implementação é trazer uma forma simples e gradual de aprendizado da contextualização das execução das triggers

## Passo a passo

**1°** Copie os códigos do Arquivo TriggerHandler e TriggerHandlerTest e cole dentro de Classes de mesmo nome na sua ORG.

**2°** Cria uma classe, por exemplo para trigger de conta crie AccountTriggerHandler, estenda classe TriggerHandler, caso tenha dúvida utilize o código de exemplo AccountTriggerHandler.
> public class AccountTriggerHandler extends TriggerHandler

**3°** Crie uma trigger, para seguirmos o exemplo de conta crie AccountTrigger, adicione os contextos de execução, instancie AccountTriggerHandler e execute os métodos run ou runByRecordtype.

> trigger AccountTrigger on Account (before insert)

> new AccountTriggerHandler().run(); // sem contextualização de recordtype

> new AccountTriggerHandler().runByRecordtype('DeveloperName do RT aqui'); // com contextualização de recordtype

**4°** Agora é só utilizar seus métodos contextualizados em AccountTrigger

> protected override void beforeInsert()

## Contexto das Triggers

Quando criamos uma trigger temos que dizer qual o objeto e em qual momento o evento será disparado, e para isso fazemos dessa forma:

> trigger [Nome da Trigger] on [Objeto Salesforce] ([before insert, after insert, before update, after update, before delete, after delete, after undelete])

Quando devemos usar cada um desses momentos de disparos e como isso é contextualizado na nossa Trigger Handler?

**before insert**: Executa quando você insere um novo registro. Os valores que você alterar nos objetos da trigger serão persistidos no banco. Modo de uso: Adicione o contexto na trigger e sobrescreva um dos seguintes métodos na sua implementação de trigger handler
> protected override void beforeInsert() { }

> protected override void beforeInsert(List<SObject> listNew) {} //dessa forma você recebe os Objetos Salesforce já contextualizados por parâmetro, caso a execução seja por Recordtype os dados aqui vão estar filtrados

**before update**: Executa quando você atualiza um registro. Os valore que você alterar nos objetos da trigger serão persistidos no banco. Modo de uso: Adicione o contexto na trigger e sobrescreva um dos seguintes métodos na sua implementação de trigger handler

> protected override void beforeUpdate() { }

> protected override void beforeUpdate(Map<Id, SObject> mapNew, Map<Id, SObject> mapOld) { }

**before delete**: Executa quando você deleta um registro. Modo de uso: Adicione o contexto na trigger e sobrescreva um dos seguintes métodos na sua implementação de trigger handler

> protected override void beforeDelete() { }

> protected override void beforeDelete(Map<Id, SObject> mapOld) { }

**after insert**: Executa quando você cria um registro. Nesse contexto você já tem acesso ao Id do registro, pois o mesmo já está comitado na base. Modo de uso: Adicione o contexto na trigger e sobrescreva um dos seguintes métodos na sua implementação de trigger handler

> protected override void afterInsert() { }

> protected override void afterInsert(Map<Id, SObject> mapNew) { }

**after update**: Executa quando você atualiza um registro. Nesse contexto, o mesmo já está comitado na base. Modo de uso: Adicione o contexto na trigger e sobrescreva um dos seguintes métodos na sua implementação de trigger handler

> protected override void afterUpdate() { }

> protected override void afterUpdate(Map<Id, SObject> mapNew, Map<Id, SObject> mapOld) { }

**after delete**: Executa quando você deleta um registro. Nesse contexto, o objeto já foi removido da base. Modo de uso: Adicione o contexto na trigger e sobrescreva um dos seguintes métodos na sua implementação de trigger handler

> protected override void afterDelete() { }

> protected override void afterDelete(Map<Id, SObject> mapOld) { }

**after undelete**: Executa quando você recupera um registro da lixeira. Modo de uso: Adicione o contexto na trigger e sobrescreva um dos seguintes métodos na sua implementação de trigger handler

> protected override void afterUndelete() {}

> protected override void afterUndelete(Map<Id, SObject> mapNew) { }

## Acesso aos Objetos da Trigger

A forma mais simples de acessas os objetos da trigger é acessá-los diretamente pelos atributos da classes Trigger, porém esses atributos podem retornar null ao invés de uma lista vazia e isso pode quebrar o seu código se as tratativas corretas não forem feitas. Para facilitar a sua vida essa implementação já encapsula e trata dos atributos de atributos de forma que eles nunca retornem null, você só precisa acessados de uma das seguintes formas:

**Usar os métodos com parâmetros**: quando você utiliza os métodos que recebem esses valores parâmetro os mesmos já estão tratados e em caso de execução por Record Type eles também já estão filtrados.

**Trigger.new** :

Substitua usar isso:

```List<Account> listNew = (List<Account>) Trigger.new;```

por isso:

```List<Account> listNew = (List<Account>) this.getTriggerNew();```

**Trigger.old** :

Substitua usar isso:

```List<Account> listOld = (List<Account>) Trigger.old;```

por isso:

```List<Account> listOld = (List<Account>) this.getTriggerOld();```


**Trigger.newMap** :

Substitua usar isso:

```List<Account> mapNew= (List<Account>) Trigger.newMap;```

por isso:

```List<Account> mapNew= (List<Account>) this.getTriggerMapNew();```

  
**Trigger.oldMap** :

Substitua usar isso:

```List<Account> mapOld = (List<Account>) Trigger.oldMap;```

por isso:

```List<Account> mapOld = (List<Account>) this.getTriggerMapOld();```

  
**Você também pode resgatar os Objetos filtrando por Record Type** :

Trigger.new tratado, encapsulado e filtrado:

```List<Account> listNewExRecordType = (List<Account>) this.getTriggerNewByRecordTypeDeveloperName('ExRecordType');```

Trigger.old tratado, encapsulado e filtrado:

```List<Account> listOldExRecordType = (List<Account>) this.getTriggerOldByRecordTypeDeveloperName('ExRecordType'); ```

Trigger.newMap tratado, encapsulado e filtrado:

```Map<Id, Account> mapNewExRecordType = (Map<Id, Account>) this.getTriggerNewMapByRecordTypeDeveloperName('ExRecordType');```

Trigger.oldMap tratado, encapsulado e filtrado:

```Map<Id, Account> mapOldExRecordType = (Map<Id, Account>) this.getTriggerOldMapByRecordTypeDeveloperName('ExRecordType');```
