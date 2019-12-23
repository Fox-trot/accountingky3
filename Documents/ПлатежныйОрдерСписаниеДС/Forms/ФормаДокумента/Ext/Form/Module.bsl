﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();

	Если Параметры.Ключ.Пустая() Тогда
		УстановитьНачальныеСвойстваСубконтоТаблицы();
	КонецЕсли;		

	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
	УстановитьУсловноеОформление();

	// РаботаСФормами
	РаботаСФормамиСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец РаботаСФормами
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УстановитьНачальныеСвойстваСубконтоТаблицы();
		
	// СтандартныеПодсистемы.ДатыЗапретаИзменений
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменений
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом 
	
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)	
	
	УстановитьНачальныеСвойстваСубконтоТаблицы();
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
		
		УстановитьКурсВалютыДокумента();
	КонецЕсли;	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	Объект.Номер = "";
	Объект.БанковскийСчет = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьОсновнойБанковскийСчетОрганизации(Объект.Организация);
	ОбработатьИзменениеБанковскогоСчетаОрганизации();
	
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоТаблицыПриИзмененииОрганизации(
		Объект.ПрочиеПлатежи,
		ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("УстановитьПиктограммуКомментария", 0.1, Истина);
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Банковский счет организации.
//
&НаКлиенте
Процедура БанковскийСчетПриИзменении(Элемент)
	ОбработатьИзменениеБанковскогоСчетаОрганизации();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПрочиеПлатежи

// Процедура - обработчик события ПередНачаломИзменения таблицы ПрочиеПлатежи.
//
&НаКлиенте
Процедура ПрочиеПлатежиПередНачаломИзменения(Элемент, Отказ)
	ТекущиеДанные = Элементы.ПрочиеПлатежи.ТекущиеДанные;
	
	БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоСтроки(
		ЭтотОбъект, ТекущиеДанные, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
КонецПроцедуры

// Процедура - обработчик события ПередНачаломДобавления таблицы ПрочиеПлатежи.
//
&НаКлиенте
Процедура ПрочиеПлатежиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Копирование Тогда
		ИтогСуммаПлатежа = Объект.ПрочиеПлатежи.Итог("СуммаПлатежа") + Элемент.ТекущиеДанные.СуммаПлатежа;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ПрочиеПлатежиПослеУдаления(Элемент)
	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ПрочиеПлатежиСуммаПлатежа.
//
&НаКлиенте
Процедура ПрочиеПлатежиСуммаПлатежаПриИзменении(Элемент)
	ОбновитьПодвалФормы();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ПрочиеПлатежиСчетРасчетов.
//
&НаКлиенте
Процедура ПрочиеПлатежиСчетРасчетовПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ПрочиеПлатежи.ТекущиеДанные;
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоСтрокиПриИзмененииСчета(
		ЭтотОбъект, ТекущиеДанные, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ПрочиеПлатежиСубконто1.
//
&НаКлиенте
Процедура ПрочиеПлатежиСубконто1ПриИзменении(Элемент)
	ПриИзмененииСубконто(1);
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода ПрочиеПлатежиСубконто1.
//
&НаКлиенте
Процедура ПрочиеПлатежиСубконто1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ПрочиеПлатежиСубконто2.
//
&НаКлиенте
Процедура ПрочиеПлатежиСубконто2ПриИзменении(Элемент)
	ПриИзмененииСубконто(2);
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода ПрочиеПлатежиСубконто2.
//
&НаКлиенте
Процедура ПрочиеПлатежиСубконто2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ПрочиеПлатежиСубконто3.
//
&НаКлиенте
Процедура ПрочиеПлатежиСубконто3ПриИзменении(Элемент)
	ПриИзмененииСубконто(3);
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора поля ввода ПрочиеПлатежиСубконто3.
//
&НаКлиенте
Процедура ПрочиеПлатежиСубконто3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("РазностьДат",	РазностьДат);
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

// Процедура - устанавливает курс документа на дату.
//
&НаСервере
Процедура УстановитьКурсВалютыДокумента()
	Объект.Курс = 1;	
	Объект.Кратность = 1;	

	ВалютаДокумента = Объект.БанковскийСчет.ВалютаДенежныхСредств;
	Если ЗначениеЗаполнено(ВалютаДокумента) Тогда
		КурсВалюты = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДокумента, ДатаДокумента);
		Объект.Курс = КурсВалюты.Курс;
		Объект.Кратность = КурсВалюты.Кратность;
			
		Если НЕ ЗначениеЗаполнено(Объект.Курс) Тогда
			Объект.Курс = 1;	
			Объект.Кратность = 1;	
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры // УстановитьКурсВалютыДокумента()

&НаКлиенте
Процедура ОбработатьИзменениеБанковскогоСчетаОрганизации()
	
	СтруктураДанные = ПолучитьДанныеБанковскийСчетПриИзменении(ДатаДокумента, Объект.БанковскийСчет);

	// Обработка изменения валюты.
	Объект.ВалютаДокумента = СтруктураДанные.ВалютаДокумента;
	Объект.Курс      = ?(СтруктураДанные.ВалютаДокументаКурсКратность.Курс = 0, 1, СтруктураДанные.ВалютаДокументаКурсКратность.Курс);
	Объект.Кратность = ?(СтруктураДанные.ВалютаДокументаКурсКратность.Кратность = 0, 1, СтруктураДанные.ВалютаДокументаКурсКратность.Кратность);
КонецПроцедуры

// Получает набор данных с сервера для процедуры БанковскийСчетОрганизацииПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеБанковскийСчетПриИзменении(Период, БанковскийСчет)
	
	СтруктураДанные = Новый Структура;
	
	СтруктураДанные.Вставить(
		"ВалютаДокумента",
		БанковскийСчет.ВалютаДенежныхСредств);
		
	СтруктураДанные.Вставить(
		"ВалютаДокументаКурсКратность",
		РаботаСКурсамиВалют.ПолучитьКурсВалюты(БанковскийСчет.ВалютаДенежныхСредств, Период));

	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеБанковскийСчетПриИзменении()

// Процедура рассчитывает итоги для подвала формы.
//
&НаКлиенте
Процедура ОбновитьПодвалФормы()
	ИтогСуммаПлатежа = Объект.ПрочиеПлатежи.Итог("СуммаПлатежа");
КонецПроцедуры // ОбновитьПодвалФормы()

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииРаботаССубконто

// Процедура настройки условного оформления форм и динамических списков .
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// Таблица ПрочиеПлатежи.
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ПрочиеПлатежиСубконто1");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПрочиеПлатежи.Субконто1Доступность");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ПрочиеПлатежиСубконто2");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПрочиеПлатежи.Субконто2Доступность");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ПрочиеПлатежиСубконто3");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПрочиеПлатежи.Субконто3Доступность");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

КонецПроцедуры

&НаСервере
Процедура УстановитьНачальныеСвойстваСубконтоТаблицы()
	БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоТаблицы(
		Объект.ПрочиеПлатежи,
		ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыУстановкиСвойствСубконто(Форма)

	Результат = БухгалтерскийУчетКлиентСервер.ПараметрыУстановкиСвойствСубконтоПоШаблону(
		"ПрочиеПлатежиСубконто", "Субконто", "СчетРасчетов");
	
	Результат.ДопРеквизиты.Вставить("Организация", Форма.Объект.Организация);
	Результат.СкрыватьСубконто = Ложь;
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ПриИзмененииСубконто(НомерСубконто)
	
	СтрокаТаблицы = Элементы.ПрочиеПлатежи.ТекущиеДанные;
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоСтрокиПриИзмененииСубконто(
		ЭтотОбъект, 
		СтрокаТаблицы,
		НомерСубконто, 
		ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДанныеОбъекта = БухгалтерскийУчетКлиентСервер.ДанныеУстановкиПараметровСубконто(
		Элементы.ПрочиеПлатежи.ТекущиеДанные, 
		ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
