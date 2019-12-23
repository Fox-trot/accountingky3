﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не АвтономнаяРаботаСлужебный.ЭтоАвтономноеРабочееМесто() Тогда
		ВызватьИсключение НСтр("ru = 'Эта информационная база не является автономным рабочим местом.'");
	КонецЕсли;
	
	ПриложениеВСервисе = АвтономнаяРаботаСлужебный.ПриложениеВСервисе();
	
	РегламентноеЗадание = РегламентныеЗаданияСервер.ПолучитьРегламентноеЗадание(
		Метаданные.РегламентныеЗадания.СинхронизацияДанныхСПриложениемВИнтернете);
	
	СинхронизироватьДанныеПоРасписанию = РегламентноеЗадание.Использование;
	РасписаниеСинхронизацииДанных      = РегламентноеЗадание.Расписание;
	
	ПриИзмененииРасписанияСинхронизацииДанных();
	
	СинхронизироватьДанныеПриНачалеРаботыПрограммы = Константы.СинхронизироватьДанныеСПриложениемВИнтернетеПриНачалеРаботыПрограммы.Получить();
	СинхронизироватьДанныеПриЗавершенииРаботыПрограммы = Константы.СинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииРаботыПрограммы.Получить();
	
	АдресДляВосстановленияПароляУчетнойЗаписи = АвтономнаяРаботаСлужебный.АдресДляВосстановленияПароляУчетнойЗаписи();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	ОбновитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ОбновитьВидимость", 60);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ВыполненОбменДанными" Тогда
		ОбновитьВидимость();
		
	ИначеЕсли ИмяСобытия = "ИзмененыНастройкиПользователя" Тогда
		ОбновитьВидимость();
		
	ИначеЕсли ИмяСобытия = "Запись_НастройкиТранспортаОбмена" Тогда
		
		Если Параметр.Свойство("НастройкаАвтоматическойСинхронизации") Тогда
			СинхронизироватьДанныеПоРасписанию = Истина;
			СинхронизироватьДанныеПоРасписаниюПриИзмененииЗначения();
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ЗакрытаФормаРезультатовОбменаДанными" Тогда
		ОбновитьЗаголовокПереходаККонфликтам();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПредупреждениеОДолгойСинхронизацииПриИзменении(Элемент)
	
	ПереключитьПредупреждениеОДолгойСинхронизации(ПоказыватьПредупреждениеОДолгойСинхронизации);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьСинхронизациюДанных(Команда)
	
	ОбменДаннымиКлиент.ВыполнитьОбменДаннымиОбработкаКоманды(ПриложениеВСервисе, ЭтотОбъект, АдресДляВосстановленияПароляУчетнойЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписаниеСинхронизацииДанных(Команда)
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеСинхронизацииДанных);
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьРасписаниеСинхронизацииДанныхЗавершение", ЭтотОбъект);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписаниеСинхронизацииДанныхЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Если Расписание <> Неопределено Тогда
		
		РасписаниеСинхронизацииДанных = Расписание;
		
		ИзменитьРасписаниеСинхронизацииДанныхНаСервере();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОбновление(Команда)
	
	ОбменДаннымиКлиент.УстановитьОбновлениеКонфигурации();
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьДанныеПоРасписаниюПриИзменении(Элемент)
	
	Если СинхронизироватьДанныеПоРасписанию И Не ПарольПользователяСохраняется Тогда
		
		СинхронизироватьДанныеПоРасписанию = Ложь;
		
		НастроитьПодключениеКСервису(Истина);
		
	Иначе
		
		СинхронизироватьДанныеПоРасписаниюПриИзмененииЗначения();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРасписанияСинхронизацииДанныхПриИзменении(Элемент)
	
	ВариантРасписанияСинхронизацииДанныхПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьДанныеПриНачалеРаботыПрограммыПриИзменении(Элемент)
	
	УстановитьЗначениеКонстанты_СинхронизироватьДанныеСПриложениемВИнтернетеПриНачалеРаботыПрограммы(
		СинхронизироватьДанныеПриНачалеРаботыПрограммы);
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьДанныеПриЗавершенииРаботыПрограммыПриИзменении(Элемент)
	
	УстановитьЗначениеКонстанты_СинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииРаботыПрограммы(
		СинхронизироватьДанныеПриЗавершенииРаботыПрограммы);
		
	ИмяПараметра = "СтандартныеПодсистемы.ПредлагатьСинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииСеанса";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Неопределено);
	КонецЕсли;

	ПараметрыПриложения["СтандартныеПодсистемы.ПредлагатьСинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииСеанса"] =
		СинхронизироватьДанныеПриЗавершенииРаботыПрограммы;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПодключение(Команда)
	
	НастроитьПодключениеКСервису();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиККонфликтам(Команда)
	
	УзлыОбмена = Новый Массив;
	УзлыОбмена.Добавить(ПриложениеВСервисе);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("УзлыОбмена", УзлыОбмена);
	ОткрытьФорму("РегистрСведений.РезультатыОбменаДанными.Форма.Форма", ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьВидимость()
	
	ОбновитьВидимостьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПредставлениеДатыСинхронизации = ОбменДаннымиСервер.ПредставлениеДатыСинхронизации(
		АвтономнаяРаботаСлужебный.ДатаПоследнейУспешнойСинхронизации(ПриложениеВСервисе));
	Элементы.ИнформацияОПоследнейСинхронизации.Заголовок = ПредставлениеДатыСинхронизации + ".";
	Элементы.ИнформацияОПоследнейСинхронизации1.Заголовок = ПредставлениеДатыСинхронизации + ".";
	
	ОбновитьЗаголовокПереходаККонфликтам();
	
	ТребуетсяУстановкаОбновления = ОбменДаннымиСервер.ТребуетсяУстановкаОбновления();
	
	Элементы.АвтономнаяРабота.ТекущаяСтраница = ?(ТребуетсяУстановкаОбновления,
		Элементы.ПолученоОбновлениеКонфигурации,
		Элементы.СинхронизацияДанных);
	
	Элементы.ВыполнитьСинхронизациюДанных.КнопкаПоУмолчанию         = Не ТребуетсяУстановкаОбновления;
	Элементы.ВыполнитьСинхронизациюДанных.АктивизироватьПоУмолчанию = Не ТребуетсяУстановкаОбновления;
	
	Элементы.УстановитьОбновление.КнопкаПоУмолчанию         = ТребуетсяУстановкаОбновления;
	Элементы.УстановитьОбновление.АктивизироватьПоУмолчанию = ТребуетсяУстановкаОбновления;
	
	НастройкиТранспортаWS = РегистрыСведений.НастройкиТранспортаОбменаДанными.НастройкиТранспортаWS(ПриложениеВСервисе);
	
	ПарольПользователяСохраняется = НастройкиТранспортаWS.WSЗапомнитьПароль;
	
	СинхронизироватьДанныеПоРасписанию = РегламентныеЗаданияСервер.РегламентноеЗаданиеИспользуется(Метаданные.РегламентныеЗадания.СинхронизацияДанныхСПриложениемВИнтернете);
	
	Элементы.НастроитьПодключение.Доступность = СинхронизироватьДанныеПоРасписанию;
	Элементы.ВариантРасписанияСинхронизацииДанных.Доступность = СинхронизироватьДанныеПоРасписанию;
	Элементы.ИзменитьРасписаниеСинхронизацииДанных.Доступность = СинхронизироватьДанныеПоРасписанию;
	
	Элементы.ИзменитьРасписаниеСинхронизацииДанных.Видимость = Не ОбщегоНазначения.ЭтоМобильныйКлиент();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	// Устанавливаем видимость по ролям
	РольДоступнаНастройкаСинхронизацииДанных = ОбменДаннымиСервер.ЕстьПраваНаАдминистрированиеОбменов();
	Элементы.НастройкаСинхронизацииДанных.Видимость = РольДоступнаНастройкаСинхронизацииДанных;
	Элементы.УстановитьОбновление.Видимость = РольДоступнаНастройкаСинхронизацииДанных;
	
	Если РольДоступнаНастройкаСинхронизацииДанных Тогда
		Элементы.ПоясняющаяНадписьПолученоОбновление.Заголовок = НСтр("ru = 'Получено обновление программы из Интернета.
			|Необходимо установить полученное обновление, после чего синхронизация будет продолжена.'");
	Иначе
		Элементы.ПоясняющаяНадписьПолученоОбновление.Заголовок = НСтр("ru = 'Получено обновление программы из Интернета.
			|Обратитесь к администратору информационной базы для установки полученного обновления.'");
	КонецЕсли;
	
	ПоказыватьПредупреждениеОДолгойСинхронизации = АвтономнаяРаботаСлужебный.ФлагНастройкиВопросаОДолгойСинхронизации();
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокПереходаККонфликтам()
	
	Если ОбменДаннымиПовтИсп.ИспользуетсяВерсионирование() Тогда
		
		СтруктураЗаголовка = ОбменДаннымиСервер.СтруктураЗаголовкаГиперссылкиМонитораПроблем(ПриложениеВСервисе);
		
		ЗаполнитьЗначенияСвойств (Элементы.ПерейтиККонфликтам, СтруктураЗаголовка);
		ЗаполнитьЗначенияСвойств (Элементы.ПерейтиККонфликтам1, СтруктураЗаголовка);
		
	Иначе
		
		Элементы.ПерейтиККонфликтам.Видимость = Ложь;
		Элементы.ПерейтиККонфликтам1.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВариантРасписанияСинхронизацииДанныхПриИзмененииНаСервере()
	
	НовоеРасписаниеСинхронизацииДанных = "";
	
	Если ВариантРасписанияСинхронизацииДанных = 1 Тогда
		
		НовоеРасписаниеСинхронизацииДанных = ПредопределенноеРасписаниеВариант1();
		
	ИначеЕсли ВариантРасписанияСинхронизацииДанных = 2 Тогда
		
		НовоеРасписаниеСинхронизацииДанных = ПредопределенноеРасписаниеВариант2();
		
	ИначеЕсли ВариантРасписанияСинхронизацииДанных = 3 Тогда
		
		НовоеРасписаниеСинхронизацииДанных = ПредопределенноеРасписаниеВариант3();
		
	Иначе // 4
		
		НовоеРасписаниеСинхронизацииДанных = ПользовательскоеРасписаниеСинхронизацииДанных;
		
	КонецЕсли;
	
	Если Строка(РасписаниеСинхронизацииДанных) <> Строка(НовоеРасписаниеСинхронизацииДанных) Тогда
		
		РасписаниеСинхронизацииДанных = НовоеРасписаниеСинхронизацииДанных;
		
		РегламентныеЗаданияСервер.УстановитьРасписаниеРегламентногоЗадания(
			Метаданные.РегламентныеЗадания.СинхронизацияДанныхСПриложениемВИнтернете,
			РасписаниеСинхронизацииДанных);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПереключитьПредупреждениеОДолгойСинхронизации(Знач Флаг)
	
	АвтономнаяРаботаСлужебный.ФлагНастройкиВопросаОДолгойСинхронизации(Флаг);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРасписанияСинхронизацииДанных()
	
	Элементы.ВариантРасписанияСинхронизацииДанных.СписокВыбора.Очистить();
	Элементы.ВариантРасписанияСинхронизацииДанных.СписокВыбора.Добавить(1, НСтр("ru = 'Каждые 15 минут'"));
	Элементы.ВариантРасписанияСинхронизацииДанных.СписокВыбора.Добавить(2, НСтр("ru = 'Каждый час'"));
	Элементы.ВариантРасписанияСинхронизацииДанных.СписокВыбора.Добавить(3, НСтр("ru = 'Каждый день в 10:00, кроме сб. и вс.'"));
	
	// Определяем текущий вариант расписания синхронизации данных
	ВариантыРасписанияСинхронизацииДанных = Новый Соответствие;
	ВариантыРасписанияСинхронизацииДанных.Вставить(Строка(ПредопределенноеРасписаниеВариант1()), 1);
	ВариантыРасписанияСинхронизацииДанных.Вставить(Строка(ПредопределенноеРасписаниеВариант2()), 2);
	ВариантыРасписанияСинхронизацииДанных.Вставить(Строка(ПредопределенноеРасписаниеВариант3()), 3);
	
	ВариантРасписанияСинхронизацииДанных = ВариантыРасписанияСинхронизацииДанных[Строка(РасписаниеСинхронизацииДанных)];
	
	Если ВариантРасписанияСинхронизацииДанных = 0 Тогда
		
		ВариантРасписанияСинхронизацииДанных = 4;
		Элементы.ВариантРасписанияСинхронизацииДанных.СписокВыбора.Добавить(4, Строка(РасписаниеСинхронизацииДанных));
		ПользовательскоеРасписаниеСинхронизацииДанных = РасписаниеСинхронизацииДанных;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьРасписаниеСинхронизацииДанныхНаСервере()
	
	РегламентныеЗаданияСервер.УстановитьРасписаниеРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.СинхронизацияДанныхСПриложениемВИнтернете,
		РасписаниеСинхронизацииДанных);
	
	ПриИзмененииРасписанияСинхронизацииДанных();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьЗначениеКонстанты_СинхронизироватьДанныеСПриложениемВИнтернетеПриНачалеРаботыПрограммы(Знач Значение)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Константы.СинхронизироватьДанныеСПриложениемВИнтернетеПриНачалеРаботыПрограммы.Установить(Значение);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьЗначениеКонстанты_СинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииРаботыПрограммы(Знач Значение)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Константы.СинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииРаботыПрограммы.Установить(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПодключениеКСервису(НастройкаАвтоматическойСинхронизации = Ложь)
	
	Отбор              = Новый Структура("Узел", ПриложениеВСервисе);
	ЗначенияЗаполнения = Новый Структура("Узел", ПриложениеВСервисе);
	ПараметрыФормы     = Новый Структура;
	ПараметрыФормы.Вставить("АдресДляВосстановленияПароляУчетнойЗаписи", АдресДляВосстановленияПароляУчетнойЗаписи);
	ПараметрыФормы.Вставить("НастройкаАвтоматическойСинхронизации", НастройкаАвтоматическойСинхронизации);
	
	ОбменДаннымиКлиент.ОткрытьФормуЗаписиРегистраСведенийПоОтбору(Отбор,
		ЗначенияЗаполнения, "НастройкиТранспортаОбменаДанными", ЭтотОбъект, "НастройкаПодключенияКСервису", ПараметрыФормы);
	
	ОбновитьВидимостьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьДанныеПоРасписаниюПриИзмененииЗначения()
	
	УстановитьИспользованиеРегламентногоЗадания(СинхронизироватьДанныеПоРасписанию);
	
	Элементы.НастроитьПодключение.Доступность = СинхронизироватьДанныеПоРасписанию;
	Элементы.ВариантРасписанияСинхронизацииДанных.Доступность = СинхронизироватьДанныеПоРасписанию;
	Элементы.ИзменитьРасписаниеСинхронизацииДанных.Доступность = СинхронизироватьДанныеПоРасписанию;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьИспользованиеРегламентногоЗадания(Знач СинхронизироватьДанныеПоРасписанию)
	
	РегламентныеЗаданияСервер.УстановитьИспользованиеРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.СинхронизацияДанныхСПриложениемВИнтернете,
		СинхронизироватьДанныеПоРасписанию);
	
КонецПроцедуры

// Предопределенные расписания синхронизации данных

&НаСервереБезКонтекста
Функция ПредопределенноеРасписаниеВариант1() // Каждые 15 минут
	
	Месяцы = Новый Массив;
	Месяцы.Добавить(1);
	Месяцы.Добавить(2);
	Месяцы.Добавить(3);
	Месяцы.Добавить(4);
	Месяцы.Добавить(5);
	Месяцы.Добавить(6);
	Месяцы.Добавить(7);
	Месяцы.Добавить(8);
	Месяцы.Добавить(9);
	Месяцы.Добавить(10);
	Месяцы.Добавить(11);
	Месяцы.Добавить(12);
	
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	ДниНедели.Добавить(6);
	ДниНедели.Добавить(7);
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.Месяцы                   = Месяцы;
	Расписание.ДниНедели                = ДниНедели;
	Расписание.ПериодПовтораВТечениеДня = 60*15; // 15 минут
	Расписание.ПериодПовтораДней        = 1; // каждый день
	
	Возврат Расписание;
КонецФункции

&НаСервереБезКонтекста
Функция ПредопределенноеРасписаниеВариант2() // Каждый час
	
	Возврат АвтономнаяРаботаСлужебный.РасписаниеСинхронизацииДанныхПоУмолчанию();
	
КонецФункции

&НаСервереБезКонтекста
Функция ПредопределенноеРасписаниеВариант3() // Каждый день в 10:00, кроме сб. и вс.
	
	Месяцы = Новый Массив;
	Месяцы.Добавить(1);
	Месяцы.Добавить(2);
	Месяцы.Добавить(3);
	Месяцы.Добавить(4);
	Месяцы.Добавить(5);
	Месяцы.Добавить(6);
	Месяцы.Добавить(7);
	Месяцы.Добавить(8);
	Месяцы.Добавить(9);
	Месяцы.Добавить(10);
	Месяцы.Добавить(11);
	Месяцы.Добавить(12);
	
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.Месяцы            = Месяцы;
	Расписание.ДниНедели         = ДниНедели;
	Расписание.ВремяНачала       = Дата('00010101100000'); // 10:00
	Расписание.ПериодПовтораДней = 1; // каждый день
	
	Возврат Расписание;
КонецФункции

#КонецОбласти
