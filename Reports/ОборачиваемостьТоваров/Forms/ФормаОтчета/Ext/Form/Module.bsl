﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания; 

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура ЗаполнитьНастройкамиПоУмолчанию(ЗаполняемыеНастройки)
	
	Если ЗаполняемыеНастройки.Свойство("Показатели") И ЗаполняемыеНастройки.Показатели Тогда
		// Управление показателями
		Отчет.ПоказательСумма = Ложь;
		Отчет.ПоказательКоличество = Истина;
		Отчет.КоэффициентОборачиваемости = Ложь;
		Отчет.ПериодОборачиваемости = Истина;

	КонецЕсли;
	
	Если ЗаполняемыеНастройки.Свойство("Группировка") И ЗаполняемыеНастройки.Группировка Тогда
		
		Отчет.Группировка.Очистить();
		
		НоваяГруппировка                = Отчет.Группировка.Добавить();
		НоваяГруппировка.Поле           = "Склад";
		НоваяГруппировка.Представление  = "Склад";
		НоваяГруппировка.Использование  = Ложь;
		НоваяГруппировка.ТипГруппировки = 0;
		
		НоваяГруппировка                = Отчет.Группировка.Добавить();
		НоваяГруппировка.Поле           = "Номенклатура";
		НоваяГруппировка.Представление  = "Номенклатура";
		НоваяГруппировка.Использование  = Истина;
		НоваяГруппировка.ТипГруппировки = 0;
		
	КонецЕсли;
	
	Отчет.БазаРасчета = "Количество";
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИсходныеЗначения(Форма)
	
	Форма.ОрганизацияИсходноеЗначение = Форма.ПолеОрганизация;
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Отчет.РежимРасшифровки Тогда
		КлючТекущегоВарианта = "ОборачиваемостьТоваров";
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	УстановитьПараметрыВыбораСчета();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если НЕ ИнформационнаяБазаФайловая Тогда
		
		Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
			ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
		Иначе
			ПодключитьОбработчикОжидания("Подключаемый_СформироватьПриОткрытии", БухгалтерскиеОтчетыКлиент.ИнтервалЗапускаФормированияОтчетаПриОткрытии(), Истина);
		КонецЕсли;
		
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	
	ОбновитьИсходныеЗначения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка) 
	
	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтаФорма, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка);
	ПользовательскиеНастройкиМодифицированы = НЕ Отчет.РежимРасшифровки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	БухгалтерскиеОтчетыКлиент.ПриЗакрытии(ЭтаФорма, ЗавершениеРаботы);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	Если Не КомпоновщикИнициализирован Тогда
		ПользовательскиеНастройки = ПоместитьВоВременноеХранилище(Настройки, УникальныйИдентификатор);
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервереВОтчетеРуководителю(ЭтотОбъект, Настройки);
	
	Если Не КомпоновщикИнициализирован И ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		ИнициализацияКомпоновщикаНастроек();
	КонецЕсли;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	ОбновитьИсходныеЗначения(ЭтаФорма);
	
	Если ИнформационнаяБазаФайловая Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	Если Отчет.РежимРасшифровки Тогда
		Отчет.Группировка.Очистить();
		Отчет.ДополнительныеПоля.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	ЗаполнитьНастройкамиПоУмолчанию(Новый Структура("Показатели, Группировка", Истина, Истина));

КонецПроцедуры

&НаСервере
Процедура ИнициализацияКомпоновщикаНастроек()
	
	БухгалтерскиеОтчетыВызовСервера.ИнициализацияКомпоновщикаНастроек(ЭтаФорма, ОрганизацияИзменилась, "ОборачиваеомостьТоваров");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ПЕРИОД

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", Отчет.НачалоПериода, Отчет.КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(Отчет, РезультатВыбора, "НачалоПериода,КонецПериода");
	
	ОбновитьТекстЗаголовка(ЭтаФорма); 
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	ОбновитьТекстЗаголовка(ЭтаФорма);
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	ОбновитьТекстЗаголовка(ЭтаФорма);
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПолеОрганизацияПриИзменении(Элемент)
	
	Если ОрганизацияИсходноеЗначение = ПолеОрганизация Тогда
		Возврат;
	КонецЕсли;
	
	ОрганизацияИзменилась = Истина;
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияПриИзменении(Элемент, ПолеОрганизация, Отчет.Организация);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	Если КомпоновщикИнициализирован Тогда
		БухгалтерскиеОтчетыКлиент.ОрганизацияПриИзменении(ЭтаФорма, Элемент);
	КонецЕсли;
	
	ОбновитьИсходныеЗначения(ЭтаФорма);
	
	БухгалтерскиеОтчетыКлиент.ОрганизацияПриИзменении(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка,
		ПолеОрганизация, СоответствиеОрганизаций);
		
КонецПроцедуры
	
&НаКлиенте
Процедура ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка, 
		СоответствиеОрганизаций, Отчет.Организация);
	
КонецПроцедуры

/////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЯ РЕЗУЛЬТАТА

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ОбработкаРасшифровкиСтандартногоОтчета(ЭтаФорма, Элемент, Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ГРУППИРОВКА

&НаКлиенте
Процедура ГруппировкаПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);  
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Ложь;
		СтрокаТаблицы.ИспользованиеВДиаграмме = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Истина;
		СтрокаТаблицы.ИспользованиеВДиаграмме = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОТБОРЫ

&НаКлиенте
Процедура ОтборыПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПриИзменении(ЭтаФорма, Элемент, Ложь);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЛевоеЗначение = ЭтаФорма.Элементы.Отборы.ТекущиеДанные.ЛевоеЗначение;
	ТекущийВидСравнения = ЭтаФорма.Элементы.Отборы.ТекущиеДанные.ВидСравнения;
	
	ПолеКомпоновкиДанныхСчет = Новый ПолеКомпоновкиДанных("Счет");
	
	Если ЛевоеЗначение = ПолеКомпоновкиДанныхСчет 
		И (ТекущийВидСравнения <> ВидСравненияКомпоновкиДанных.ВСписке 
		И ТекущийВидСравнения <> ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии
		И ТекущийВидСравнения <> ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии
		И ТекущийВидСравнения <> ВидСравненияКомпоновкиДанных.НеВСписке) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ФормаВыбораСчета = ПолучитьФорму("ПланСчетов.Хозрасчетный.ФормаВыбора",,Элемент);
		ФормаВыбораСчета.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ФормаВыбораСчета.Список.Отбор,"Ссылка", СписокСчетов, ВидСравненияКомпоновкиДанных.ВСписке);
		
		ФормаВыбораСчета.Открыть();
		
	Иначе
		
		СписокПараметров = ПолучитьПараметрыВыбораЗначенияОтбора();
		БухгалтерскиеОтчетыКлиент.ОтборыПравоеЗначениеНачалоВыбора(ЭтаФорма, Элемент, ДанныеВыбора, СтандартнаяОбработка, СписокПараметров);
		
	КонецЕсли;
	
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ДОПОЛНИТЕЛЬНЫЕ ПОЛЯ

&НаКлиенте
Процедура РазмещениеДополнительныхПолейПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ СОРТИРОВКА

&НаКлиенте
Процедура СортировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОФОРМЛЕНИЕ

&НаКлиенте
Процедура МакетОформленияПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Отчет.КомпоновщикНастроек.Настройки, "МакетОформления", МакетОформления);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаголовокПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПодвалПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ЗапуститьФормированиеОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.СформироватьОтчет.КнопкаПоУмолчанию = Истина;
	СкрытьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	
	Если Не КомпоновщикИнициализирован Тогда
		ИнициализацияКомпоновщикаНастроек();
	КонецЕсли;
	
	ОткрытьНастройки();
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	
	БухгалтерскиеОтчетыКлиент.ОтправитьОтчет(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРассылкуОтчета(Команда)
	
	ЗаполнитьНастройкиОтчетаДляРассылки();
	
	РассылкаОтчетовБПКлиент.НастроитьРассылкуИзОтчета(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РаскрытьНаВесьЭкран(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Заголовок", Заголовок);
	ПараметрыОткрытия.Вставить("Результат", АдресХранилищаРезультата());

	ОткрытьФорму("ОбщаяФорма.ФормаПредпросмотраОтчета", ПараметрыОткрытия, ЭтаФорма);
	ТекущийЭлемент = Элементы.СформироватьОтчет;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьПараметрыВыбораСчета()

	СписокСчетов.ЗагрузитьЗначения(БухгалтерскиеОтчеты.СчетаУчетаТоваров());

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Функция ПодготовитьПараметрыОтчетаНаСервере()

	МенеджерОтчета = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ЭтотОбъект.ИмяФормы);
	
	ПараметрыОтчета = МенеджерОтчета.ПустыеПараметрыКомпоновкиОтчета();
	
	ПараметрыОтчета.НачалоПериода                     = Отчет.НачалоПериода;
	ПараметрыОтчета.КонецПериода                      = Отчет.КонецПериода;
	ПараметрыОтчета.ПоказательСумма                   = Отчет.ПоказательСумма;
	ПараметрыОтчета.ПоказательКоличество              = Отчет.ПоказательКоличество;
	ПараметрыОтчета.Организация                       = Отчет.Организация;
	ПараметрыОтчета.РазмещениеДополнительныхПолей     = Отчет.РазмещениеДополнительныхПолей;
	ПараметрыОтчета.ПериодОборачиваемости             = Отчет.ПериодОборачиваемости;
	ПараметрыОтчета.КоэффициентОборачиваемости        = Отчет.КоэффициентОборачиваемости;
	ПараметрыОтчета.ИзменениеПрошлогоПериода          = Отчет.ИзменениеПрошлогоПериода;
	ПараметрыОтчета.БазаРасчета                       = Отчет.БазаРасчета;
	ПараметрыОтчета.Группировка                       = Отчет.Группировка.Выгрузить();
	ПараметрыОтчета.ДополнительныеПоля                = Отчет.ДополнительныеПоля.Выгрузить();
	
	ПараметрыОтчета.ВыводитьЗаголовок                 = ВыводитьЗаголовок;
	ПараметрыОтчета.ВыводитьПодвал                    = ВыводитьПодвал;
	ПараметрыОтчета.МакетОформления                   = МакетОформления;
	ПараметрыОтчета.РежимРасшифровки                  = Отчет.РежимРасшифровки;
	ПараметрыОтчета.ДанныеРасшифровки                 = ДанныеРасшифровки;
	ПараметрыОтчета.ПоказательРасшифровки             = ПоказательРасшифровки;
	ПараметрыОтчета.РасчетныйПоказательРасшифровки    = РасчетныйПоказательРасшифровки;
	ПараметрыОтчета.СхемаКомпоновкиДанных             = ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных);
	ПараметрыОтчета.ИдентификаторОтчета               = БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтотОбъект);
	ПараметрыОтчета.НастройкиКомпоновкиДанных         = Отчет.КомпоновщикНастроек.ПолучитьНастройки();
	
	// В целях оптимизации изменяем периодичность получения остатков.
	// Ориентируемся на то, что год не является високосным.
	ЧислоДнейПериода = (КонецДня(Отчет.КонецПериода) + 1 - Отчет.НачалоПериода)/(60*60*24);
	ЧислоДнейВГоду = 365;
	Если ЧислоДнейПериода < ЧислоДнейВГоду * 3 Тогда
		Периодичность = "День";
	Иначе
		Периодичность = "Месяц";
	КонецЕсли;
	ПараметрыОтчета.Периодичность = Периодичность;
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	Если Отчет.РежимРасшифровки Тогда
		ТекстЗаголовка = НСтр("ru = 'Расшифровка оборачиваемости товаров'");
	Иначе
		ТекстЗаголовка = НСтр("ru = 'Оборачиваемость товаров'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Отчет.Организация) И Форма.ИспользуетсяНесколькоОрганизаций Тогда
		ЗаголовокОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка + "%1 %2", 
				БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода),
				БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(Отчет.Организация));
	Иначе
		ЗаголовокОтчета = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка + "%1",
				БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Отчет.НачалоПериода, Отчет.КонецПериода));
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	
	Если Режим = "Выбор" Тогда
		Для Каждого ДоступноеПоле Из Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
			Если Не Строка(ДоступноеПоле.Поле) = "Номенклатура" Тогда
				СписокПолей.Добавить(Строка(ДоступноеПоле.Поле));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Режим = "Группировка" ИЛИ Режим = "Выбор" ИЛИ Режим = "Отбор" Тогда
		СписокПолей.Добавить("Склад");
		БухгалтерскиеОтчетыКлиент.ДобавитьПоляРесурсовВЗапрещенныеПоля(ЭтаФорма, СписокПолей);
	КонецЕсли;
	
	Если Режим = "Отбор" Тогда
		СписокПолей.Добавить("КоличествоРасход");
		СписокПолей.Добавить("СуммаРасход");
		БухгалтерскиеОтчетыКлиент.ДобавитьПоляРесурсовВЗапрещенныеПоля(ЭтаФорма, СписокПолей);
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если Не КомпоновщикИнициализирован Тогда
		ИнициализацияКомпоновщикаНастроек();
	КонецЕсли;
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Новый Структура("ЗаданиеВыполнено, ОтказПроверкиЗаполнения", Истина, Истина);
	КонецЕсли;
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчетаНаСервере();
	
	Если ИнформационнаяБазаФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет", 
			ПараметрыОтчета, 
			БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
			
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанныеНаСервере();
	КонецЕсли;
	
	Элементы.СформироватьОтчет.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанныеНаСервере()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат         = РезультатВыполнения.Результат;
	ДанныеРасшифровки = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанныеНаСервере();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройки()
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыВыбораЗначенияОтбора()
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Организация"       , Отчет.Организация);
	
	Возврат СписокПараметров;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_СформироватьПриОткрытии()
	
	ЗапуститьФормированиеОтчета();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьФормированиеОтчета()
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ПоказатьНастройки("");
	Иначе
		СкрытьНастройки();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ИзменениеСхемыКомпоновкиДанныхНаСервере() Экспорт
	
	Если Отчет.РежимРасшифровки Тогда
		СКДРасшифровки = Отчеты.ОборачиваемостьТоваров.ПолучитьМакет("СхемаРасшифровки");
		СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(СКДРасшифровки, УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиОтчетаДляРассылки()
	
	// Для получения корректных настроек, необходимо предварительно инициализировать компоновщик настроек.
	Если НЕ КомпоновщикИнициализирован Тогда
		ИнициализацияКомпоновщикаНастроек();
	КонецЕсли;
	
	РассылкаОтчетовБП.ЗаполнитьНастройкиОтчетаДляРассылки(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция АдресХранилищаРезультата()
	
	Возврат ПоместитьВоВременноеХранилище(Результат, УникальныйИдентификатор);
	
КонецФункции
