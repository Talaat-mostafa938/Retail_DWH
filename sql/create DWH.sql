use master;
go

if db_id('RetailDWH') is null
    create database RetailDWH;
go

use RetailDWH;
go

if schema_id('stg') is null
    exec('create schema stg');
go


if schema_id('dim') is null
    exec('create schema dim');
go

if schema_id('fact') is null
    exec('create schema fact');
go

