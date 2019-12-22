﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Выгрузка загрузка данных".
//
////////////////////////////////////////////////////////////////////////////////

// Процедуры и функции данного модуля содержат служебные события, на которые может подписаться
// прикладной разработчик для расширенной возможности выгрузки и загрузки данных.
//

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает версию интерфейса обработчиков выгрузки / загрузки данных 1.0.0.0.
//
Функция ВерсияОбработчиков1_0_0_0() Экспорт
	
	Возврат "1.0.0.0";
	
КонецФункции

// Возвращает версию интерфейса обработчиков выгрузки / загрузки данных 1.0.0.1.
//
Функция ВерсияОбработчиков1_0_0_1() Экспорт
	
	Возврат "1.0.0.1";
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Инициализация событий при выгрузке данных

// Формирует массив метаданных, требующих аннотацию ссылок при выгрузке.
//
// Возвращаемое значение:
//	ФиксированныйМассив - массив метаданных.
//
Функция ПолучитьТипыТребующиеАннотациюСсылокПриВыгрузке() Экспорт
	
	Типы = Новый Массив();
	
	// Обработчики событий библиотек
	ИнтеграцияПодсистемБТС.ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы);
	
	// Интегрированные обработчики
	ВыгрузкаЗагрузкаНеразделенныхДанных.ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы);
	ВыгрузкаЗагрузкаСовместноРазделенныхДанных.ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы);
	ВыгрузкаЗагрузкаПредопределенныхДанных.ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы);
	ВыгрузкаЗагрузкаУзловПлановОбменов.ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы);
	
	Возврат Новый ФиксированныйМассив(Типы);
	
КонецФункции

// Формирует массив метаданных, поддерживающих сопоставление ссылок при загрузке.
//
// Возвращаемое значение:
//	ФиксированныйМассив - массив метаданных.
//
Функция ПолучитьТипыОбщихДанныхПоддерживающиеСопоставлениеСсылокПриЗагрузке() Экспорт
	
	Типы = Новый Массив();
	
	// Обработчики событий библиотек
	ИнтеграцияПодсистемБТС.ПриЗаполненииТиповОбщихДанныхПоддерживающихСопоставлениеСсылокПриЗагрузке(Типы);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповОбщихДанныхПоддерживающихСопоставлениеСсылокПриЗагрузке(Типы);
	
	Возврат Новый ФиксированныйМассив(Типы);
	
КонецФункции

// Формирует массив метаданных, не требующих сопоставление ссылок при загрузке.
//
// Возвращаемое значение:
//	ФиксированныйМассив - массив метаданных.
//
Функция ПолучитьТипыОбщихДанныхНеТребующихСопоставлениеСсылокПриЗагрузке() Экспорт
	
	Типы = Новый Массив();
	
	// Обработчики событий библиотек
	ИнтеграцияПодсистемБТС.ПриЗаполненииТиповОбщихДанныхНеТребующихСопоставлениеСсылокПриЗагрузке(Типы);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповОбщихДанныхНеТребующихСопоставлениеСсылокПриЗагрузке(Типы);
	
	Возврат Новый ФиксированныйМассив(Типы);
	
КонецФункции

// Формирует массив метаданных, исключаемых из загрузки/выгрузки.
//
// Возвращаемое значение:
//	ФиксированныйМассив - массив метаданных.
//
Функция ПолучитьТипыИсключаемыеИзВыгрузкиЗагрузки() Экспорт
	
	Типы = Новый Массив();
	
	РаботаВБезопасномРежимеСлужебныйВМоделиСервиса.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	
	Если ИнтеграцияПодсистемБТС.ПодсистемаСуществует("ТехнологияСервиса.ИнформационныйЦентр") Тогда
		МодульИнформационныйЦентрСлужебный = ИнтеграцияПодсистемБТС.ОбщийМодуль("ИнформационныйЦентрСлужебный");
		МодульИнформационныйЦентрСлужебный.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБТС.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменДаннымиВМоделиСервиса") Тогда
		МодульОбменДаннымиВМоделиСервиса = ИнтеграцияПодсистемБТС.ОбщийМодуль("ОбменДаннымиВМоделиСервиса");
		МодульОбменДаннымиВМоделиСервиса.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБТС.ПодсистемаСуществует("ТехнологияСервиса.РасширенияВМоделиСервиса") Тогда
		МодульРасширенияВМоделиСервиса = ИнтеграцияПодсистемБТС.ОбщийМодуль("РасширенияВМоделиСервиса");
		МодульРасширенияВМоделиСервиса.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБТС.ПодсистемаСуществует("ТехнологияСервиса.ЦентрКонтроляКачества") Тогда
		МодульИнцидентыЦККСлужебный = ИнтеграцияПодсистемБТС.ОбщийМодуль("ИнцидентыЦККСлужебный");
		МодульИнцидентыЦККСлужебный.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБТС.ПодсистемаСуществует("ТехнологияСервиса.УправлениеТарифами") Тогда
		МодульТарификацияСлужебный = ИнтеграцияПодсистемБТС.ОбщийМодуль("ТарификацияСлужебный");
		МодульТарификацияСлужебный.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБТС.ПодсистемаСуществует("ТехнологияСервиса.ПроверкаИКорректировкаДанных") Тогда
		МодульПроверкаИКорректировкаДанных = ИнтеграцияПодсистемБТС.ОбщийМодуль("ПроверкаИКорректировкаДанных");
		МодульПроверкаИКорректировкаДанных.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБТС.ПодсистемаСуществует("ТехнологияСервиса.МиграцияПриложений") Тогда
		МодульМиграцияПриложений = ИнтеграцияПодсистемБТС.ОбщийМодуль("МиграцияПриложений");
		МодульМиграцияПриложений.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБТС.ПодсистемаСуществует("ТехнологияСервиса.ОчередьЗаданийВнешнийИнтерфейс") Тогда
		МодульОчередьЗаданийВнешнийИнтерфейс = ИнтеграцияПодсистемБТС.ОбщийМодуль("ОчередьЗаданийВнешнийИнтерфейс");
		МодульОчередьЗаданийВнешнийИнтерфейс.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБТС.ПодсистемаСуществует("ТехнологияСервиса.ПоставляемыеДанныеАбонентов") Тогда
		МодульПоставляемыеДанныеАбонентов = ИнтеграцияПодсистемБТС.ОбщийМодуль("ПоставляемыеДанныеАбонентов");
		МодульПоставляемыеДанныеАбонентов.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	Если ИнтеграцияПодсистемБТС.ПодсистемаСуществует("ТехнологияСервиса.ИнтеграцияОбъектовОбластейДанных") Тогда
		МодульИнтеграцияОбъектовОбластейДанных = ИнтеграцияПодсистемБТС.ОбщийМодуль("ИнтеграцияОбъектовОбластейДанных");
		МодульИнтеграцияОбъектовОбластейДанных.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	КонецЕсли;
	
	// Обработчики событий библиотек
	ИнтеграцияПодсистемБТС.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы);
	
	Возврат Новый ФиксированныйМассив(Типы);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Инициализация событий при загрузке данных


// Возвращает зависимости типов при замене ссылок.
//
// Возвращаемое значение:
//	Соответствие:
//		Ключ - Строка - имя метаданных, которые зависят от других метаданных.
//		Значение - Массив - массив имен метаданных от которых зависит объект метаданных, хранящееся в ключе.
//
Функция ПолучитьЗависимостиТиповПриЗаменеСсылок() Экспорт
	
	// Интегрированные обработчики
	Возврат ВыгрузкаЗагрузкаНеразделенныхДанных.ЗависимостиТиповПриЗаменеСсылок();
	
КонецФункции

// Выполняет ряд действий после загрузки данных
//
// Параметры:
//  Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//    контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//    к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера,
//  Сериализация - ОбъектXDTO {http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1}InfoBaseUser,
//    сериализация пользователя информационной базы,
//  ПользовательИБ - ПользовательИнформационнойБазы, десериализованный из выгрузки,
//  Отказ - Булево, при установке значения данного параметры внутри этой процедуры в
//    значение Ложь загрузка пользователя информационной базы будет пропущена.
//
Процедура ВыполнитьДействияПриЗагрузкеПользователяИнформационнойБазы(Контейнер, Сериализация, ПользовательИБ, Отказ) Экспорт
	
	// Обработчики событий библиотек
	ИнтеграцияПодсистемБТС.ПриЗагрузкеПользователяИнформационнойБазы(Контейнер, Сериализация, ПользовательИБ, Отказ);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗагрузкеПользователяИнформационнойБазы(Контейнер, Сериализация, ПользовательИБ, Отказ);
	
КонецПроцедуры

// Выполняет ряд действий после загрузки пользователя информационной базы.
//
// Параметры:
//  Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//    контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//    к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера,
//  Сериализация - ОбъектXDTO {http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1}InfoBaseUser,
//    сериализация пользователя информационной базы,
//  ПользовательИБ - ПользовательИнформационнойБазы, десериализованный из выгрузки.
//
Процедура ВыполнитьДействияПослеЗагрузкиПользователяИнформационнойБазы(Контейнер, Сериализация, ПользовательИБ) Экспорт
	
	// Обработчики событий библиотек
	ИнтеграцияПодсистемБТС.ПослеЗагрузкиПользователяИнформационнойБазы(Контейнер, Сериализация, ПользовательИБ);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПослеЗагрузкиПользователяИнформационнойБазы(Контейнер, Сериализация, ПользовательИБ);
	
КонецПроцедуры

// Выполняет ряд действий после загрузки пользователей информационной базы.
//
// Параметры:
//  Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер
//    контейнера, используемый в процессе загрузки данных. Подробнее см. комментарий
//    к программному интерфейсу обработки ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера.
//
Процедура ВыполнитьДействияПослеЗагрузкиПользователейИнформационнойБазы(Контейнер) Экспорт
	
	// Обработчики событий библиотек
	ИнтеграцияПодсистемБТС.ПослеЗагрузкиПользователейИнформационнойБазы(Контейнер);
	
	// Переопределяемая процедура
	ВыгрузкаЗагрузкаДанныхПереопределяемый.ПослеЗагрузкиПользователейИнформационнойБазы(Контейнер);
	
КонецПроцедуры

#КонецОбласти