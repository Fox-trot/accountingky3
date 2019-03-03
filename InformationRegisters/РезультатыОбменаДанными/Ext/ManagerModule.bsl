﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗарегистрироватьУстранениеПроблемы(Источник, ТипПроблемы, УзелИнформационнойБазы = Неопределено) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	МетаданныеОбъекта = Источник.Метаданные();
	
	Если ОбщегоНазначения.ЭтоРегистр(МетаданныеОбъекта) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбменДаннымиПовтИсп.ОбъектыДляРегистрацииПроблемСДаннымиПриЗагрузке().Получить(МетаданныеОбъекта) = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторОбъектаМетаданных      = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(МетаданныеОбъекта);
	ЗначенияОтборовНезависимогоРегистра = Неопределено;
	СсылкаНаИсточник                    = Источник.Ссылка;
	НовоеЗначениеПометкиУдаления        = Источник.ПометкаУдаления;
		
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбменДаннымиПовтИсп.ИспользуемыеПланыОбмена().Количество() > 0
		И (БезопасныйРежим() = Ложь Или Пользователи.ЭтоПолноправныйПользователь()) Тогда
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
		
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.РезультатыОбменаДанными");
			ЭлементБлокировки.УстановитьЗначение("ТипПроблемы", ТипПроблемы);
			Если ЗначениеЗаполнено(УзелИнформационнойБазы) Тогда
				ЭлементБлокировки.УстановитьЗначение("УзелИнформационнойБазы", УзелИнформационнойБазы);				
			КонецЕсли;
			ЭлементБлокировки.УстановитьЗначение("ОбъектМетаданных", ИдентификаторОбъектаМетаданных);				
			ЭлементБлокировки.УстановитьЗначение("ПроблемныйОбъект", СсылкаНаИсточник);
			
			Блокировка.Заблокировать();
			
			НаборЗаписейКонфликта = СоздатьНаборЗаписей();
			НаборЗаписейКонфликта.Отбор.ТипПроблемы.Установить(ТипПроблемы);
			Если ЗначениеЗаполнено(УзелИнформационнойБазы) Тогда
				НаборЗаписейКонфликта.Отбор.УзелИнформационнойБазы.Установить(УзелИнформационнойБазы);			
			КонецЕсли;
			НаборЗаписейКонфликта.Отбор.ОбъектМетаданных.Установить(ИдентификаторОбъектаМетаданных);
			НаборЗаписейКонфликта.Отбор.ПроблемныйОбъект.Установить(СсылкаНаИсточник);
			
			НаборЗаписейКонфликта.Прочитать();
			
			Если НаборЗаписейКонфликта.Количество() > 0 Тогда
				
				Если НовоеЗначениеПометкиУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаИсточник, "ПометкаУдаления") Тогда
					Для Каждого ЗаписьКонфликта Из НаборЗаписейКонфликта Цикл
						ЗаписьКонфликта.ПометкаУдаления = НовоеЗначениеПометкиУдаления;
					КонецЦикла;
					НаборЗаписейКонфликта.Записать();
				Иначе
					НаборЗаписейКонфликта.Очистить();
					НаборЗаписейКонфликта.Записать();
				КонецЕсли;
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗарегистрироватьОшибкуПроверкиОбъекта(ПроблемныйОбъект, УзелИнформационнойБазы, Причина, ТипПроблемы) Экспорт
	
	МетаданныеОбъекта                   = ПроблемныйОбъект.Метаданные();
	ИдентификаторОбъектаМетаданных      = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(МетаданныеОбъекта);
	Ссылка                              = Неопределено;
	ЗначенияОтборовНезависимогоРегистра = Неопределено;
	
	Если ОбщегоНазначения.ЭтоОбъектСсылочногоТипа(МетаданныеОбъекта) Тогда
		Ссылка = ПроблемныйОбъект;
	ИначеЕсли ОбщегоНазначения.ЭтоРегистр(МетаданныеОбъекта) Тогда
		
		Если ОбщегоНазначения.ЭтоРегистрСведений(МетаданныеОбъекта)
			И МетаданныеОбъекта.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.Независимый Тогда
			
			ЗначенияОтборовНезависимогоРегистра = Новый Структура();
			
			Для Каждого ЭлементОтбора Из ПроблемныйОбъект.Отбор Цикл
				ЗначенияОтборовНезависимогоРегистра.Вставить(ЭлементОтбора.Имя, ЭлементОтбора.Значение);
			КонецЦикла;
			
			ЗначенияОтборовНезависимогоРегистра = НаборЗаписейРегистраПоПараметрамОтбора(ЗначенияОтборовНезависимогоРегистра);
			
		Иначе
			Ссылка = ПроблемныйОбъект.Отбор.Регистратор.Значение;
		КонецЕсли;	
	Иначе
		Возврат;
	КонецЕсли;
	
	НаборЗаписейКонфликта = СоздатьНаборЗаписей();
	НаборЗаписейКонфликта.Отбор.ТипПроблемы.Установить(ТипПроблемы);
	НаборЗаписейКонфликта.Отбор.УзелИнформационнойБазы.Установить(УзелИнформационнойБазы);
	НаборЗаписейКонфликта.Отбор.ОбъектМетаданных.Установить(ИдентификаторОбъектаМетаданных);
	НаборЗаписейКонфликта.Отбор.ПроблемныйОбъект.Установить(ПроблемныйОбъект);
	
	Если ЗначенияОтборовНезависимогоРегистра <> Неопределено Тогда
		НаборЗаписейКонфликта.Отбор.КлючУникальности.Установить(
			РассчитатьХэшНезависимогоРегистра(СериализоватьЗначенияОтбора(ЗначенияОтборовНезависимогоРегистра)));
	КонецЕсли;
	
	ЗаписьКонфликта = НаборЗаписейКонфликта.Добавить();
	ЗаписьКонфликта.ТипПроблемы            = ТипПроблемы;
	ЗаписьКонфликта.УзелИнформационнойБазы = УзелИнформационнойБазы;
	ЗаписьКонфликта.ОбъектМетаданных       = ИдентификаторОбъектаМетаданных;
	ЗаписьКонфликта.ПроблемныйОбъект       = Ссылка;
	ЗаписьКонфликта.ДатаВозникновения      = ТекущаяДатаСеанса();
	ЗаписьКонфликта.Причина                = СокрЛП(Причина);
	ЗаписьКонфликта.ПредставлениеОбъекта   = Строка(ПроблемныйОбъект); 
	ЗаписьКонфликта.Пропущена              = Ложь;
	
	Если ЗначенияОтборовНезависимогоРегистра <> Неопределено Тогда
		ЗаписьКонфликта.КлючУникальности = РассчитатьХэшНезависимогоРегистра(
			СериализоватьЗначенияОтбора(ЗначенияОтборовНезависимогоРегистра));
		ЗаписьКонфликта.ЗначенияОтборовНезависимогоРегистра = ЗначенияОтборовНезависимогоРегистра;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоОбъектСсылочногоТипа(МетаданныеОбъекта) Тогда
		
		Если ТипПроблемы = Перечисления.ТипыПроблемОбменаДанными.НепроведенныйДокумент Тогда
			
			Если Ссылка.Метаданные().ДлинаНомера > 0 Тогда
				ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПроблемныйОбъект, "ПометкаУдаления, Номер, Дата");
				ЗаписьКонфликта.НомерДокумента = ЗначенияРеквизитов.Номер;
			Иначе
				ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПроблемныйОбъект, "ПометкаУдаления, Дата");
			КонецЕсли;
			
			ЗаписьКонфликта.ДатаДокумента   = ЗначенияРеквизитов.Дата;
			ЗаписьКонфликта.ПометкаУдаления = ЗначенияРеквизитов.ПометкаУдаления;
			
		Иначе
			
			ЗаписьКонфликта.ПометкаУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПроблемныйОбъект, "ПометкаУдаления");
			
		КонецЕсли;
		
	КонецЕсли;
	
	НаборЗаписейКонфликта.Записать();
	
КонецПроцедуры

Процедура ОчиститьПроблемыПриОтправке(УзлыИнформационнойБазы = Неопределено) Экспорт

	ТипыПроблем = Новый Массив();
	ТипыПроблем.Добавить(Перечисления.ТипыПроблемОбменаДанными.ОшибкаПроверкиСконвертированногоОбъекта);
	ТипыПроблем.Добавить(Перечисления.ТипыПроблемОбменаДанными.ОшибкаВыполненияКодаОбработчиковПриОтправкеДанных);
	
	Для Каждого Проблема Из ТипыПроблем Цикл
		
		ПоляОтбора = ПараметрыОтборыРегистра();
		
		Если ЗначениеЗаполнено(УзлыИнформационнойБазы) Тогда
			
			Если ТипЗнч(УзлыИнформационнойБазы) = Тип("Массив") Тогда
				Для Каждого УзелИнформационнойБазы Из УзлыИнформационнойБазы Цикл
					
					ПоляОтбора.ТипПроблемы            = Проблема;
					ПоляОтбора.УзелИнформационнойБазы = УзелИнформационнойБазы;
					ОчиститьЗаписиРегистра(ПоляОтбора);
					
				КонецЦикла;
			Иначе
				
				ПоляОтбора.ТипПроблемы            = Проблема;
				ПоляОтбора.УзелИнформационнойБазы = УзлыИнформационнойБазы;
				ОчиститьЗаписиРегистра(ПоляОтбора);
				
			КонецЕсли;
			
		Иначе	
			ПоляОтбора.ТипПроблемы = Проблема;
			ОчиститьЗаписиРегистра(ПоляОтбора);
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры	

Процедура ОчиститьПроблемыПриПолучении(УзлыИнформационнойБазы = Неопределено) Экспорт

	ТипыПроблем = Новый Массив();
	ТипыПроблем.Добавить(Перечисления.ТипыПроблемОбменаДанными.ОшибкаВыполненияКодаОбработчиковПриПолученииДанных);
	
	Для Каждого Проблема Из ТипыПроблем Цикл
		
		ПоляОтбора = ПараметрыОтборыРегистра();
		
		Если ЗначениеЗаполнено(УзлыИнформационнойБазы) Тогда
			
			Если ТипЗнч(УзлыИнформационнойБазы) = Тип("Массив") Тогда
				Для Каждого УзелИнформационнойБазы Из УзлыИнформационнойБазы Цикл
					
					ПоляОтбора.ТипПроблемы            = Проблема;
					ПоляОтбора.УзелИнформационнойБазы = УзелИнформационнойБазы;
					ОчиститьЗаписиРегистра(ПоляОтбора);
					
				КонецЦикла;
			Иначе
				
				ПоляОтбора.ТипПроблемы            = Проблема;
				ПоляОтбора.УзелИнформационнойБазы = УзлыИнформационнойБазы;
				ОчиститьЗаписиРегистра(ПоляОтбора);
				
			КонецЕсли;
			
		Иначе	
			ПоляОтбора.ТипПроблемы = Проблема;
			ОчиститьЗаписиРегистра(ПоляОтбора);
		КонецЕсли;
	
	КонецЦикла;

КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СериализоватьЗначенияОтбора(ПараметрыОтбора)
	
	НаборЗаписейКонфликта = НаборЗаписейРегистраПоПараметрамОтбора(ПараметрыОтбора);
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
    ЗаписатьXML(ЗаписьXML, НаборЗаписейКонфликта);
	
	Возврат ЗаписьXML.Закрыть();

КонецФункции

Функция ПараметрыОтборыРегистра()
	
	ПоляОтбора = Новый Структура();
	ПоляОтбора.Вставить("ТипПроблемы",            Перечисления.ТипыПроблемОбменаДанными.ПустаяСсылка());
	ПоляОтбора.Вставить("УзелИнформационнойБазы", Неопределено);
	ПоляОтбора.Вставить("ОбъектМетаданных",       Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка());
	ПоляОтбора.Вставить("ПроблемныйОбъект",       Неопределено);
	ПоляОтбора.Вставить("КлючУникальности",       "");
	
	Возврат ПоляОтбора;
	
КонецФункции

Процедура ОчиститьЗаписиРегистра(ПараметрыОтбора)
	
	НаборЗаписейКонфликта = НаборЗаписейРегистраПоПараметрамОтбора(ПараметрыОтбора);
	НаборЗаписейКонфликта.Записать();
	
КонецПроцедуры

Функция РассчитатьХэшНезависимогоРегистра(СериализованныеЗначенияОтбора)
	
	ХешОтбораМД5 = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешОтбораМД5.Добавить(СериализованныеЗначенияОтбора);
	
	ХешСуммаОтбора = ХешОтбораМД5.ХешСумма;
	ХешСуммаОтбора = СтрЗаменить(ХешСуммаОтбора, " ", "");
	
	Возврат ХешСуммаОтбора;

КонецФункции

Процедура Игнорировать(Ссылка, ТипПроблемы, Игнорировать, УзелИнформационнойБазы = Неопределено) Экспорт
	
	МетаданныеОбъекта              = Ссылка.Метаданные();
	ИдентификаторОбъектаМетаданных = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(МетаданныеОбъекта);
	
	НаборЗаписейКонфликта = СоздатьНаборЗаписей();
	НаборЗаписейКонфликта.Отбор.ПроблемныйОбъект.Установить(Ссылка);
	НаборЗаписейКонфликта.Отбор.ТипПроблемы.Установить(ТипПроблемы);
	НаборЗаписейКонфликта.Отбор.ОбъектМетаданных.Установить(ИдентификаторОбъектаМетаданных);	
	
	Если ЗначениеЗаполнено(УзелИнформационнойБазы) Тогда
		НаборЗаписейКонфликта.Отбор.УзелИнформационнойБазы.Установить(УзелИнформационнойБазы);	
	КонецЕсли;
	
	НаборЗаписейКонфликта.Прочитать();
	НаборЗаписейКонфликта[0].Пропущена = Игнорировать;
	НаборЗаписейКонфликта.Записать();
	
КонецПроцедуры

Функция ПараметрыПоискаПроблем() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ТипПроблемы",                Неопределено);
	Параметры.Вставить("УчитыватьПроигнорированные", Ложь);
	Параметры.Вставить("Период",                     Неопределено);
	Параметры.Вставить("УзлыПланаОбмена",            Неопределено);
	Параметры.Вставить("СтрокаПоиска",               "");
	Параметры.Вставить("ПроблемныйОбъект",           Неопределено);	
	
	Возврат Параметры;
	
КонецФункции

Функция КоличествоПроблем(ПараметрыПоиска = Неопределено) Экспорт
	
	Если ПараметрыПоиска = Неопределено Тогда
		ПараметрыПоиска = ПараметрыПоискаПроблем();
	КонецЕсли;
	
	Количество = 0;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РезультатыОбменаДанными.ПроблемныйОбъект) КАК КоличествоПроблем
		|ИЗ
		|	РегистрСведений.РезультатыОбменаДанными КАК РезультатыОбменаДанными
		|ГДЕ
		|	ИСТИНА
		|	[ОтборПоПропущенным]
		|	[ОтборПоУзлуПланаОбмена]
		|	[ОтборПоТипуПроблемы]
		|	[ОтборПоПериоду]
		|	[ОтборПоПричине]
		|	[ОтборПоОбъекту]
		|");
	

	// Отбор по проигнорированным проблемам.
	Если ПараметрыПоиска.Свойство("УчитыватьПроигнорированные")
		И ЗначениеЗаполнено(ПараметрыПоиска.УчитыватьПроигнорированные)
		И ПараметрыПоиска.УчитыватьПроигнорированные Тогда
		СтрокаОтбора = "РезультатыОбменаДанными.Пропущена";
	Иначе
		СтрокаОтбора = "";
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "[ОтборПоПропущенным]", СтрокаОтбора);
	
	// Отбор по типу проблемы.
	Если ПараметрыПоиска.Свойство("ТипПроблемы") Тогда
		
		Если Не ЗначениеЗаполнено(ПараметрыПоиска.ТипПроблемы) Тогда
			СтрокаОтбора = "";
		Иначе
			Если ТипЗнч(ПараметрыПоиска.ТипПроблемы) = Тип("ПеречислениеСсылка.ТипыПроблемОбменаДанными") Тогда
				СтрокаОтбора = "И РезультатыОбменаДанными.ТипПроблемы = &ТипПроблемы";
				Запрос.УстановитьПараметр("ТипПроблемы", ПараметрыПоиска.ТипПроблемы);				
			Иначе
				СтрокаОтбора = "И РезультатыОбменаДанными.ТипПроблемы В (&ТипыПроблемы)";
				Запрос.УстановитьПараметр("ТипыПроблемы", ПараметрыПоиска.ТипПроблемы);				
			КонецЕсли;
		КонецЕсли;
	Иначе
		СтрокаОтбора = "";
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "[ОтборПоТипуПроблемы]", СтрокаОтбора);
	
	// Отбор по узлу плана обмена.
	Если ПараметрыПоиска.Свойство("УзлыПланаОбмена") 
		И ЗначениеЗаполнено(ПараметрыПоиска.УзлыПланаОбмена) Тогда
		
		Если ПланыОбмена.ТипВсеСсылки().СодержитТип(ТипЗнч(ПараметрыПоиска.УзлыПланаОбмена)) Тогда
			СтрокаОтбора = "И РезультатыОбменаДанными.УзелИнформационнойБазы = &УзелИнформационнойБазы";
			Запрос.УстановитьПараметр("УзелИнформационнойБазы", ПараметрыПоиска.УзлыПланаОбмена);
		Иначе
			СтрокаОтбора = "И РезультатыОбменаДанными.УзелИнформационнойБазы В (&УзлыОбмена)";
			Запрос.УстановитьПараметр("УзлыОбмена", ПараметрыПоиска.УзлыПланаОбмена);
		КонецЕсли;
	Иначе
		СтрокаОтбора = "";
	КонецЕсли;
		
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "[ОтборПоУзлуПланаОбмена]", СтрокаОтбора);
	
	// Отбор по периоду.
	Если ПараметрыПоиска.Свойство("Период") 
		И ЗначениеЗаполнено(ПараметрыПоиска.Период) Тогда
		
		СтрокаОтбора = "И (РезультатыОбменаДанными.ДатаВозникновения >= &ДатаНачала
		| И РезультатыОбменаДанными.ДатаВозникновения <= &ДатаОкончания)";
		Запрос.УстановитьПараметр("ДатаНачала", ПараметрыПоиска.Период.ДатаНачала);
		Запрос.УстановитьПараметр("ДатаОкончания", ПараметрыПоиска.Период.ДатаОкончания);
		
	Иначе
		СтрокаОтбора = "";
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "[ОтборПоПериоду]", СтрокаОтбора);
	
	// Отбор по причине.
	Если ПараметрыПоиска.Свойство("СтрокаПоиска") 
		И ЗначениеЗаполнено(ПараметрыПоиска.СтрокаПоиска) Тогда
		
		СтрокаОтбора = "И РезультатыОбменаДанными.Причина ПОДОБНО &Причина";
		Запрос.УстановитьПараметр("Причина", "%" + ПараметрыПоиска.СтрокаПоиска + "%");
		
	Иначе
		СтрокаОтбора = "";
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "[ОтборПоПричине]", СтрокаОтбора);
	
	// Отбор по объекту.
	Если ПараметрыПоиска.Свойство("ПроблемныеОбъекты")
		И ЗначениеЗаполнено(ПараметрыПоиска.ПроблемныеОбъекты) Тогда
		
		Если ТипЗнч(ПараметрыПоиска.ПроблемныеОбъекты) = Тип("Массив") Тогда
			СтрокаОтбора = "И РезультатыОбменаДанными.ПроблемныйОбъект В (&ПроблемныеОбъекты)";
			Запрос.УстановитьПараметр("ПроблемныеОбъекты", ПараметрыПоиска.ПроблемныеОбъекты);
		Иначе
			СтрокаОтбора = "И РезультатыОбменаДанными.ПроблемныйОбъект = &ПроблемныйОбъект";
			Запрос.УстановитьПараметр("ПроблемныйОбъект", ПараметрыПоиска.ПроблемныеОбъекты);
		КонецЕсли;	
		
	Иначе
		СтрокаОтбора = "";
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "[ОтборПоОбъекту]", СтрокаОтбора);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Количество = Выборка.КоличествоПроблем;
		
	КонецЕсли;
	
	Возврат Количество;
	
КонецФункции

Функция НаборЗаписейРегистраПоПараметрамОтбора(ПараметрыОтбора)
	
	НаборЗаписейКонфликта = СоздатьНаборЗаписей();
	
	Если ПараметрыОтбора.Свойство("ТипПроблемы")
		И ЗначениеЗаполнено(ПараметрыОтбора.ТипПроблемы) Тогда
		НаборЗаписейКонфликта.Отбор.ТипПроблемы.Установить(ПараметрыОтбора.ТипПроблемы);
	КонецЕсли;	
		
	Если ПараметрыОтбора.Свойство("УзелИнформационнойБазы")
		И ЗначениеЗаполнено(ПараметрыОтбора.УзелИнформационнойБазы) Тогда
		НаборЗаписейКонфликта.Отбор.УзелИнформационнойБазы.Установить(ПараметрыОтбора.УзелИнформационнойБазы);
	КонецЕсли;	
	
	Если ПараметрыОтбора.Свойство("ОбъектМетаданных")
		И ЗначениеЗаполнено(ПараметрыОтбора.ОбъектМетаданных) Тогда
		НаборЗаписейКонфликта.Отбор.ОбъектМетаданных.Установить(ПараметрыОтбора.ОбъектМетаданных);
	КонецЕсли;	
	
	Если ПараметрыОтбора.Свойство("ПроблемныйОбъект")
		И ЗначениеЗаполнено(ПараметрыОтбора.ПроблемныйОбъект) Тогда
		НаборЗаписейКонфликта.Отбор.ПроблемныйОбъект.Установить(ПараметрыОтбора.ПроблемныйОбъект);
	КонецЕсли;	
	
	Если ПараметрыОтбора.Свойство("КлючУникальности")
		И ЗначениеЗаполнено(ПараметрыОтбора.КлючУникальности) Тогда
		НаборЗаписейКонфликта.Отбор.КлючУникальности.Установить(ПараметрыОтбора.КлючУникальности);
	КонецЕсли;	
	
	Возврат НаборЗаписейКонфликта;
	
КонецФункции

#КонецОбласти

#КонецЕсли