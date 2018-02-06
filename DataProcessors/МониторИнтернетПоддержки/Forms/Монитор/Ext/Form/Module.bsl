﻿
#Область ОписаниеПеременных

// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗапускИПППриСтарте = Ложь;
	
	МониторИнтернетПоддержкиПереопределяемый.ИспользоватьОтображениеМонитораПриНачалеРаботы(
		ЗапускИПППриСтарте);
	
	Элементы.ГруппаНастройкаЗапускатьПриСтарте.Видимость = (ЗапускИПППриСтарте = Истина);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ИнтернетПоддержкаПользователей",
		"ХэшОбновленияИнформационногоОкна",
		Параметры.ХэшИнформацииМонитора);
	
	ЗаголовокПользователя = Строка(Параметры.login);
	
	Элементы.НадписьЛогина.Заголовок = ЗаголовокПользователя;
	Элементы.НадписьЛогина.Подсказка = НСтр("ru = 'Логин текущего пользователя Интернет-поддержки:'")
		+ " " + ЗаголовокПользователя;
	
	ФормированиеФормы(Параметры);
	
	НастройкаЗапуска = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ИнтернетПоддержкаПользователей",
		"ВсегдаПоказыватьПриСтартеПрограммы");
	
	Если НастройкаЗапуска = Неопределено Тогда
		НастройкаПоказПриСтарте = 0;
	ИначеЕсли НастройкаЗапуска = Истина Тогда
		ПоказыватьПриОбновлении = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"ИнтернетПоддержкаПользователей",
			"ПоказПриСтартеТолькоПриИзменении");
		Если ПоказыватьПриОбновлении = Истина Тогда
			НастройкаПоказПриСтарте = 1;
		Иначе
			НастройкаПоказПриСтарте = 0;
		КонецЕсли;
	Иначе
		НастройкаПоказПриСтарте = 2;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИнтернетПоддержкаПользователейКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ЭтотОбъект);
	
#Если ВебКлиент Тогда
	ПоказатьПредупреждение(,
		НСтр("ru = 'В веб-клиенте некоторые ссылки могут работать неправильно.
			|Приносим извинения за неудобства.'"),
		,
		НСтр("ru = 'Интернет-поддержка пользователей'"));
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ПрограммноеЗакрытие Тогда
		ИнтернетПоддержкаПользователейКлиент.ЗавершитьБизнесПроцесс(КонтекстВзаимодействия, ЗавершениеРаботы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьВыходаНажатие(Элемент)
	
	ИнтернетПоддержкаПользователейКлиент.ОбработатьВыходПользователя(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура HTMLДокументПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ДанныеАктивногоЭлемента = Элемент.Документ.activeElement;
	Если ДанныеАктивногоЭлемента = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		КлассАктивногоЭлемента = ДанныеАктивногоЭлемента.HRef;
	Исключение
		Возврат;
	КонецПопытки;
	
	Попытка
		ТаргетЭлемента = ДанныеАктивногоЭлемента.target;
	Исключение
		ТаргетЭлемента = Неопределено;
	КонецПопытки;
	
	Попытка
		ЗаголовокЭлемента = ДанныеАктивногоЭлемента.innerHTML;
	Исключение
		ЗаголовокЭлемента = Неопределено;
	КонецПопытки;
	
	Если ТаргетЭлемента <> Неопределено Тогда
		
		Если НРег(СокрЛП(ТаргетЭлемента)) = "_blank" Тогда
			СтандартнаяОбработка = Ложь;
			ИнтернетПоддержкаПользователейКлиент.ОткрытьВебСтраницу(
				КлассАктивногоЭлемента,
				ЗаголовокЭлемента);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Найти(НРег(СокрЛП(КлассАктивногоЭлемента)),"openupdate") <> 0 Тогда
		
		СтандартнаяОбработка = Ложь;
		Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы") Тогда
			ПоказатьПредупреждение(
				,
				НСтр("ru = 'Отсутствует механизм автоматического обновления.'"));
			Возврат;
		КонецЕсли;
		
		
		МодульПолучениеОбновленийПрограммыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПолучениеОбновленийПрограммыКлиент");
		МодульПолучениеОбновленийПрограммыКлиент.ОбновитьПрограмму();
		
	ИначеЕсли Найти(НРег(СокрЛП(КлассАктивногоЭлемента)), "problemupdate") <> 0 Тогда
		
		СтандартнаяОбработка = Ложь;
		ТекстСообщения =
			НСтр("ru = 'При обновлении конфигурации на новый релиз возникли следующие проблемы:
				|<Опишите возникшие проблемы>.'");
		
		ЛогинПользователя = ИнтернетПоддержкаПользователейКлиентСервер.ЗначениеСессионногоПараметра(
			КонтекстВзаимодействия.КСКонтекст,
			"login");
		
		РегНомер = ИнтернетПоддержкаПользователейКлиентСервер.ЗначениеСессионногоПараметра(
			КонтекстВзаимодействия.КСКонтекст,
			"regnumber");
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения,
			ЛогинПользователя,
			РегНомер);
		
		ИнтернетПоддержкаПользователейКлиент.ОтправитьСообщениеВТехПоддержку(
			НСтр("ru = 'Интернет-поддержка. Обновление конфигурации.'"),
			ТекстСообщения,
			,
			,
			Новый Структура("Логин, Пароль",
				ЛогинПользователя,
				ИнтернетПоддержкаПользователейКлиентСервер.ЗначениеСессионногоПараметра(
					КонтекстВзаимодействия.КСКонтекст,
					"password")));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаПоказПриСтартеПриИзменении(Элемент)
	
	НастройкаПоказПриСтартеПриИзмененииНаСервере(НастройкаПоказПриСтарте);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет адрес обозревателя
&НаСервере
Процедура ФормированиеФормы(ПараметрыФормы)
	
	Если ПараметрыФормы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УРЛ = Неопределено;
	ПараметрыФормы.Свойство("УРЛ", УРЛ);
	
	Если УРЛ <> Неопределено Тогда
		HTMLДокумент = УРЛ;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура НастройкаПоказПриСтартеПриИзмененииНаСервере(НастройкаПоказПриСтарте)
	
	Если НастройкаПоказПриСтарте = 0 Тогда
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"ИнтернетПоддержкаПользователей",
			"ВсегдаПоказыватьПриСтартеПрограммы",
			Истина);
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"ИнтернетПоддержкаПользователей",
			"ПоказПриСтартеТолькоПриИзменении",
			Ложь);
	ИначеЕсли НастройкаПоказПриСтарте = 1 Тогда
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"ИнтернетПоддержкаПользователей",
			"ВсегдаПоказыватьПриСтартеПрограммы",
			Истина);
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"ИнтернетПоддержкаПользователей",
			"ПоказПриСтартеТолькоПриИзменении",
			Истина);
	Иначе
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"ИнтернетПоддержкаПользователей",
			"ВсегдаПоказыватьПриСтартеПрограммы",
			Ложь);
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"ИнтернетПоддержкаПользователей",
			"ПоказПриСтартеТолькоПриИзменении",
			Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
