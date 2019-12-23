﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьДанныеОКассире();
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИзменениеОтветственныхЛиц"
		И Параметр.ОтветственноеЛицо = ПредопределенноеЗначение("Справочник.ВидыОтветственныхЛиц.Кассир")
		И Параметр.Касса = Объект.Ссылка Тогда		
		
		ЗаполнитьДанныеОКассире();
		
	ИначеЕсли ИмяСобытия = "УдалениеОтветственныхЛиц"
		И Параметр.Организация = Объект.Владелец Тогда 
		
		ЗаполнитьДанныеОКассире();
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)	
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КассирНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	СтруктураОтбор = Новый Структура(
	"Период, Организация, ОтветственноеЛицо, Касса",
		Период,
		Объект.Владелец,
		ПредопределенноеЗначение("Справочник.ВидыОтветственныхЛиц.Кассир"),
		Объект.Ссылка);
	
	ТипЗначения = Тип("РегистрСведенийКлючЗаписи.ОтветственныеЛицаОрганизаций");
	
	ПараметрыЗаписи = Новый Массив(1);
	ПараметрыЗаписи[0] = СтруктураОтбор;
	
	КлючЗаписи = Новый(ТипЗначения, ПараметрыЗаписи);

	Параметрыформы = Новый Структура;
	Параметрыформы.Вставить("Ключ", КлючЗаписи);
		
	ОткрытьФорму("РегистрСведений.ОтветственныеЛицаОрганизаций.ФормаЗаписи", Параметрыформы, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура КассирНеЗаданНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстСообщения = НСтр("ru = 'Элемент справочника еще не записан.
			|Нажмите на кнопку ""Записать"" и повторите действие по назначению кассира.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Период", ПолучитьТекущуюДатуСеанса());
	ЗначенияЗаполнения.Вставить("Организация", Объект.Владелец);
	ЗначенияЗаполнения.Вставить("ОтветственноеЛицо", ПредопределенноеЗначение("Справочник.ВидыОтветственныхЛиц.Кассир"));
	ЗначенияЗаполнения.Вставить("Касса", Объект.Ссылка);
	Параметрыформы = Новый Структура;
	Параметрыформы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("РегистрСведений.ОтветственныеЛицаОрганизаций.ФормаЗаписи", Параметрыформы, ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьТекущуюДатуСеанса()

	Возврат ТекущаяДатаСеанса();

КонецФункции // ПолучитьТекущуюДатуСеанса()

&НаСервере
Процедура ЗаполнитьДанныеОКассире()
	ОтборПоКассе = Новый Структура("Касса", Объект.Ссылка);
	ОтветственныеЛица = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизацийРуководители(Объект.Владелец, ТекущаяДатаСеанса(), ОтборПоКассе);	
	
	Период = ОтветственныеЛица.КассирПериод;
	Кассир = ОтветственныеЛица.КассирФизЛицо;
	КассирНеЗадан = НСтр("ru = 'Назначить кассира'");
	
	Если ЗначениеЗаполнено(Кассир) Тогда 
		Элементы.Кассир.Видимость = Истина;
		Элементы.КассирНеЗадан.Видимость = Ложь;
	Иначе 
		Элементы.Кассир.Видимость = Ложь;
		Элементы.КассирНеЗадан.Видимость = Истина;
	КонецЕсли;		
КонецПроцедуры // ЗаполнитьДанныеОКассире()

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрефиксПриИзменении(Элемент)
	Если Найти(Объект.Префикс, "-") > 0 Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Нельзя в префиксе кассы использовать символ ""-"".'"));
		Объект.Префикс = СтрЗаменить(Объект.Префикс, "-", "");
	КонецЕсли;
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

#КонецОбласти
