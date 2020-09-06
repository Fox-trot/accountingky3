﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Родитель") Тогда
		Объект.Родитель = Параметры.Родитель;
	КонецЕсли;
	
	ОбновитьДоступностьКомандПоНастройкеПрав();
	
	РабочийКаталог = РаботаСФайламиСлужебныйВызовСервера.РабочийКаталогПапки(Объект.Ссылка);
	
	Если Объект.Ссылка = ПредопределенноеЗначение("Справочник.ПапкиФайлов.Шаблоны") Тогда
		Элементы.Родитель.Видимость = Ложь;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	ОбновитьПолныйПуть();
	
	ОбновитьПояснениеОблачногоСервиса();
	Элементы.ФормаНастроитьСинхронизацию.Видимость = ПравоДоступа("Редактирование", Метаданные.Справочники.УчетныеЗаписиСинхронизацииФайлов);
	Элементы.Ответственный.Видимость = ТипЗнч(Пользователи.АвторизованныйПользователь()) <> Тип("СправочникСсылка.ВнешниеПользователи");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		Если МодульУправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
			ОбновитьЭлементыДополнительныхРеквизитов();
			МодульУправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	Если ИмяСобытия = "Запись_НастройкиПравОбъектов" Тогда
		ОбновитьДоступностьКомандПоНастройкеПрав();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	РабочийКаталог = РаботаСФайламиСлужебныйВызовСервера.РабочийКаталогПапки(Объект.Ссылка);
	
	ОбновитьДоступностьКомандПоНастройкеПрав();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РодительПриИзменении(Элемент)
	
	ОбновитьПолныйПуть();
	
КонецПроцедуры

&НаКлиенте
Процедура РабочийКаталогВладельцаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Обработчик           = Новый ОписаниеОповещения("РаботыСФайламиПодключеноРабочийКаталогВладельцаНачалоВыбораПродолжение", ЭтотОбъект);
	РаботаСФайламиСлужебныйКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура РабочийКаталогВладельцаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	РодительСсылка = Объект.Родитель;
	РабочийКаталогРодителя = РаботаСФайламиСлужебныйВызовСервера.РабочийКаталогПапки(РодительСсылка);
	РабочийКаталогПапки    = РаботаСФайламиСлужебныйВызовСервера.РабочийКаталогПапки(Объект.Ссылка);
	
	РабочийКаталогПапкиУнаследованный = РабочийКаталогРодителя
		+ Объект.Наименование + ПолучитьРазделительПути();
	
	Если ПустаяСтрока(РабочийКаталогРодителя) Тогда
		
		РабочийКаталог = ""; // Новый рабочий каталог папки.
		РаботаСФайламиСлужебныйВызовСервера.ОчиститьРабочийКаталог(Объект.Ссылка);
		
	ИначеЕсли РабочийКаталогПапкиУнаследованный <> РабочийКаталогПапки Тогда
		
		РабочийКаталог = РабочийКаталогПапкиУнаследованный; // Новый рабочий каталог папки.
		РаботаСФайламиСлужебныйВызовСервера.СохранитьРабочийКаталогПапки(Объект.Ссылка, РабочийКаталог);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьСинхронизацию(Команда)
	
	НастройкаСинхронизации = ПараметрыНастройкиСинхронизации(Объект.Ссылка);
	
	Если ЗначениеЗаполнено(НастройкаСинхронизации.УчетнаяЗапись) Тогда
		ТипЗначения = Тип("РегистрСведенийКлючЗаписи.НастройкиСинхронизацииФайлов");
		ПараметрыЗаписи = Новый Массив(1);
		ПараметрыЗаписи[0] = НастройкаСинхронизации;
		
		КлючЗаписи = Новый(ТипЗначения, ПараметрыЗаписи);
	
		ПараметрыЗаписи = Новый Структура;
		ПараметрыЗаписи.Вставить("Ключ", КлючЗаписи);
	Иначе
		НастройкаСинхронизации.Вставить("ЭтоФайл", Истина);
		ПараметрыЗаписи = НастройкаСинхронизации;
	КонецЕсли;
	
	ОткрытьФорму("РегистрСведений.НастройкиСинхронизацииФайлов.Форма.ПростаяФормаЗаписиНастройки", ПараметрыЗаписи, ЭтотОбъект);
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РаботыСФайламиПодключеноРабочийКаталогВладельцаНачалоВыбораПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не РаботаСФайламиСлужебныйКлиент.РасширениеРаботыСФайламиПодключено() Тогда
		РаботаСФайламиСлужебныйКлиент.ПоказатьПредупреждениеОНеобходимостиРасширенияРаботыСФайлами(Неопределено);
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		Если Записать()= Ложь Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.Каталог = РабочийКаталог;
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = НСтр("ru = 'Все файлы (*.*)|*.*'");
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите папку'");
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		
		ИмяКаталога = ДиалогОткрытияФайла.Каталог;
		ИмяКаталога = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяКаталога);
		
		// Создать каталог для файлов
		Попытка
			СоздатьКаталог(ИмяКаталога);
			ИмяКаталогаТестовое = ИмяКаталога + "ПроверкаДоступа\";
			СоздатьКаталог(ИмяКаталогаТестовое);
			УдалитьФайлы(ИмяКаталогаТестовое);
		Исключение
			// Нет прав на создание каталога, или такой путь отсутствует.
			
			ТекстОшибки =
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Неверный путь или отсутствуют права на запись в папку ""%1""'"), ИмяКаталога);
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки, , "РабочийКаталог");
			Возврат;
		КонецПопытки;
		
		РабочийКаталог = ИмяКаталога;
		РаботаСФайламиСлужебныйВызовСервера.СохранитьРабочийКаталогПапки(Объект.Ссылка, РабочийКаталог);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПолныйПуть()
	
	ПапкаРодитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Ссылка, "Родитель");
	
	Если ЗначениеЗаполнено(ПапкаРодитель) Тогда
	
		ПолныйПуть = "";
		Пока ЗначениеЗаполнено(ПапкаРодитель) Цикл
			
			ПолныйПуть = Строка(ПапкаРодитель) + "\" + ПолныйПуть;
			ПапкаРодитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПапкаРодитель, "Родитель");
			Если Не ЗначениеЗаполнено(ПапкаРодитель) Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		ПолныйПуть = ПолныйПуть + Строка(Объект.Ссылка);
		
		Если Не ПустаяСтрока(ПолныйПуть) Тогда
			ПолныйПуть = """" + ПолныйПуть + """";
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступностьКомандПоНастройкеПрав()
	
	Если НЕ ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом")
	 ИЛИ Элементы.Найти("ФормаОбщаяКомандаНастроитьПрава") = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
	
	Если ЗначениеЗаполнено(Объект.Ссылка)
	   И НЕ МодульУправлениеДоступом.ЕстьПраво("ИзменениеПапок", Объект.Ссылка) Тогда
		
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	УправлениеПравами = ЗначениеЗаполнено(Объект.Ссылка)
		И МодульУправлениеДоступом.ЕстьПраво("УправлениеПравами", Объект.Ссылка);
		
	Если Элементы.ФормаОбщаяКомандаНастроитьПрава.Видимость <> УправлениеПравами Тогда
		Элементы.ФормаОбщаяКомандаНастроитьПрава.Видимость = УправлениеПравами;
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствами = ОбщегоНазначения.ОбщийМодуль("УправлениеСвойствами");
		МодульУправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Свойства") Тогда
		МодульУправлениеСвойствамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеСвойствамиКлиент");
		МодульУправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Функция ПараметрыНастройкиСинхронизации(ВладелецФайла)
	
	ТипВладельцаФайла = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип("СправочникСсылка.Файлы"));
	
	Отбор = Новый Структура(
	"ВладелецФайла, ТипВладельцаФайла, УчетнаяЗапись",
		ВладелецФайла,
		ТипВладельцаФайла,
		Справочники.УчетныеЗаписиСинхронизацииФайлов.ПустаяСсылка());
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиСинхронизацииФайлов.ВладелецФайла,
		|	НастройкиСинхронизацииФайлов.ТипВладельцаФайла,
		|	НастройкиСинхронизацииФайлов.УчетнаяЗапись
		|ИЗ
		|	РегистрСведений.НастройкиСинхронизацииФайлов КАК НастройкиСинхронизацииФайлов
		|ГДЕ
		|	НастройкиСинхронизацииФайлов.ВладелецФайла = &ВладелецФайла
		|	И НастройкиСинхронизацииФайлов.ТипВладельцаФайла = &ТипВладельцаФайла";
	
	Запрос.УстановитьПараметр("ВладелецФайла", ВладелецФайла);
	Запрос.УстановитьПараметр("ТипВладельцаФайла", ТипВладельцаФайла);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Количество() = 1 Тогда
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Отбор.УчетнаяЗапись = ВыборкаДетальныеЗаписи.УчетнаяЗапись;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Отбор;
	
КонецФункции

&НаСервере
Процедура ОбновитьПояснениеОблачногоСервиса()
	
	ВидимостьПояснения = Ложь;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСинхронизациюФайлов") Тогда
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	СтатусыСинхронизацииФайловСОблачнымСервисом.Файл,
			|	СтатусыСинхронизацииФайловСОблачнымСервисом.Href,
			|	СтатусыСинхронизацииФайловСОблачнымСервисом.УчетнаяЗапись.Наименование,
			|	СтатусыСинхронизацииФайловСОблачнымСервисом.УчетнаяЗапись.Сервис КАК Сервис
			|ИЗ
			|	РегистрСведений.СтатусыСинхронизацииФайловСОблачнымСервисом КАК СтатусыСинхронизацииФайловСОблачнымСервисом
			|ГДЕ
			|	СтатусыСинхронизацииФайловСОблачнымСервисом.Файл = &ВладелецФайла";
		
		Запрос.УстановитьПараметр("ВладелецФайла", Объект.Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			АдресПапкиВОблачномСервисе = РаботаСФайламиСлужебныйКлиентСервер.АдресВОблачномСервисе(
				ВыборкаДетальныеЗаписи.Сервис, ВыборкаДетальныеЗаписи.Href);
			
			ВидимостьПояснения = Истина;
			
			Элементы.ДекорацияПояснение.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(
				НСтр("ru = 'Работа с файлами ведется в облачном сервисе <a href=""%1"">%2</a>'"),
				Строка(АдресПапкиВОблачномСервисе), Строка(ВыборкаДетальныеЗаписи.УчетнаяЗаписьНаименование));
			
		КонецЦикла;
		
	КонецЕсли;
	
	Элементы.ГруппаПояснениеОблачногоСервиса.Видимость = ВидимостьПояснения;
	
КонецПроцедуры

#КонецОбласти
