﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();

	Если Объект.КурсПрихода = 0 Тогда 
		Объект.КурсПрихода = 1;
	КонецЕсли;				
	Если Объект.КурсРасхода = 0 Тогда 
		Объект.КурсРасхода = 1;
	КонецЕсли;
		
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменений
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменений
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры // ПриЧтенииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПоказатьКурсПрихода();
	ПоказатьКурсРасхода();	
	ПоказатьКР();
	УстановитьВидимостьДоступностьЭлементов();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
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
	КонецЕсли;
	Объект.КурсПрихода 	= ПолучитьКурсВалюты(Объект.ВалютаПрихода, Объект.Дата);
	Объект.КурсРасхода 	= ПолучитьКурсВалюты(Объект.ВалютаРасхода, Объект.Дата);	
	
КонецПроцедуры

//Процедура - обработчик события ПриИзменении поля ввода Организация
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Комментарий
//
&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

&НаКлиенте
Процедура ПриходРасчетныйСчетПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.ПриходРасчетныйСчет) Тогда
		СтруктураРасчетныйСчет 	= РасчетныйСчетПриИзмененииНаСервере(Объект.ПриходРасчетныйСчет);
		Объект.СчетПрихода 		= СтруктураРасчетныйСчет.СчетУчета;
		Объект.ВалютаПрихода 	= СтруктураРасчетныйСчет.ВалютаДенежныхСредств;
	КонецЕсли;
		
	Объект.КурсПрихода 			= ПолучитьКурсВалюты(Объект.ВалютаПрихода, Объект.Дата);
	ПересчетРасчетногоКурса();
	ПересчетКурсаОбмена();
	ПересчетКурсовойРазницы();
	ПоказатьКурсПрихода();
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура РасходРасчетныйСчетПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.РасходРасчетныйСчет) Тогда
		СтруктураРасчетныйСчет 	= РасчетныйСчетПриИзмененииНаСервере(Объект.РасходРасчетныйСчет);
		Объект.СчетРасхода 		= СтруктураРасчетныйСчет.СчетУчета;
		Объект.ВалютаРасхода 	= СтруктураРасчетныйСчет.ВалютаДенежныхСредств;
	КонецЕсли;

	Объект.КурсРасхода 			= ПолучитьКурсВалюты(Объект.ВалютаРасхода, Объект.Дата);
	ПересчетКурсаОбмена();
	ПересчетКурсовойРазницы();
	ПоказатьКурсРасхода();
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаПриходаПриИзменении(Элемент)
	ПриИзмененииСуммы();
	ПересчетКурсовойРазницы();
КонецПроцедуры

&НаКлиенте
Процедура СуммаРасходаПриИзменении(Элемент)
	ПриИзмененииСуммы();
	ПересчетКурсовойРазницы();
КонецПроцедуры

&НаКлиенте
Процедура КурсОбменаПриИзменении(Элемент)
	
	Если Объект.КурсОбмена = 0 Тогда
		ПересчетКурсаОбмена();
	КонецЕсли;
	Если Объект.ВалютаРасхода = ВалютаРегламентированногоУчета И НЕ Объект.ВалютаПрихода = ВалютаРегламентированногоУчета Тогда
		Объект.СуммаПрихода = Объект.СуммаРасхода * Объект.КурсОбмена;	
		
	ИначеЕсли НЕ Объект.ВалютаРасхода = ВалютаРегламентированногоУчета И Объект.ВалютаПрихода = ВалютаРегламентированногоУчета Тогда
	    Объект.СуммаПрихода = Объект.СуммаРасхода / Объект.КурсОбмена;
		
	ИначеЕсли НЕ Объект.ВалютаРасхода = ВалютаРегламентированногоУчета И НЕ Объект.ВалютаПрихода = ВалютаРегламентированногоУчета Тогда
		Объект.СуммаПрихода = Объект.СуммаРасхода * Объект.КурсОбмена;
		
	ИначеЕсли Объект.ВалютаРасхода = ВалютаРегламентированногоУчета И Объект.ВалютаПрихода = ВалютаРегламентированногоУчета Тогда
		Объект.СуммаПрихода = Объект.СуммаРасхода;		
	КонецЕсли;
	
	ПересчетКурсовойРазницы();
	ПересчетРасчетногоКурса();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Пересчитать(Команда)
	КурсОбменаПриИзменении(Неопределено)
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Видимость и доступность всех элементов формы
//
&НаКлиенте
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Элементы.ДекорацияКурсПрихода.Видимость = НЕ (Объект.ВалютаПрихода = ВалютаРегламентированногоУчета ИЛИ Объект.ВалютаПрихода = ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка"));
	Элементы.ДекорацияКурсРасхода.Видимость = НЕ (Объект.ВалютаРасхода = ВалютаРегламентированногоУчета ИЛИ Объект.ВалютаРасхода = ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка"));
	
КонецПроцедуры // УстановитьВидимостьДоступностьЭлементов()  

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("РазностьДат",	РазностьДат);
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

&НаСервереБезКонтекста
Функция ПолучитьКодСчетаУчета(СчетУчета)

	Возврат СчетУчета.Код	

КонецФункции // ПолучитьКодСчетаУчета()

&НаСервереБезКонтекста
Функция ПолучитьНаименованиеВалюты(Валюта)

	Возврат Валюта.Наименование	

КонецФункции // ПолучитьКодСчетаУчета()

&НаСервереБезКонтекста
Функция ПолучитьКурсВалюты(Валюта, Дата)
	КурсСтруктура 	= РаботаСКурсамиВалют.ПолучитьКурсВалюты(Валюта, Дата);
	Возврат КурсСтруктура.Курс;		
КонецФункции // ()

&НаКлиенте
Процедура ПоказатьКР()	
	СуммаУчетнаяПрихода = Окр(Объект.СуммаПрихода * Объект.КурсПрихода, 2);
	СуммаУчетнаяРасхода = Окр(Объект.СуммаРасхода * Объект.КурсРасхода, 2);
	КурсПрихода = Объект.КурсПрихода;
	КурсРасхода = Объект.КурсРасхода;
	СчетПрихода = Объект.СчетПрихода;
	СчетРасхода = Объект.СчетРасхода;
		
	КодСчетаПрихода = ПолучитьКодСчетаУчета(СчетПрихода);	
	КодСчетаРасхода = ПолучитьКодСчетаУчета(СчетРасхода);
	
	СуммаКР 		= СуммаУчетнаяПрихода - СуммаУчетнаяРасхода;
	Если Объект.КурсОбмена = Объект.КросскурсНБКР Тогда
		СуммаКР = 0;
		Если НЕ Объект.СуммаКР = 0 Тогда
			Объект.СуммаКР = 0;
		КонецЕсли;
	ИначеЕсли НЕ СуммаКР = Объект.СуммаКР Тогда
		Объект.СуммаКР 	= СуммаКР;
	КонецЕсли;
	
	Если Объект.ПрямойКурс Тогда
		Текст1 = "" + Объект.ВалютаРасхода + "/" + Объект.ВалютаПрихода + "  ";				
	Иначе
	    Текст1 = "" + Объект.ВалютаПрихода + "/" + Объект.ВалютаРасхода + "  ";
	КонецЕсли;
	
	// Нет курсовой разницы
	Если СуммаКР = 0 Тогда
		Текст2 = "";
		Текст3 = "";
		
	// Расход валюты, убыток
	ИначеЕсли НЕ СчетУчетаВалютный(СчетПрихода) И СчетУчетаВалютный(СчетРасхода) И СуммаКР < 0 Тогда
		Текст2 = "Курс НБКР " + СокрЛП(Строка(КурсРасхода)) + " сом/" + ПолучитьНаименованиеВалюты(Объект.ВалютаРасхода);
		Текст3 = "(убыток " + КодСчетаРасхода + "): " + Строка(-СуммаКР) + " сом";
		
		// Расход валюты, доход		
	ИначеЕсли НЕ СчетУчетаВалютный(СчетПрихода) И СчетУчетаВалютный(СчетРасхода) И СуммаКР > 0 Тогда
		Текст2 = "Курс НБКР " + СокрЛП(Строка(КурсРасхода)) + " сом/" + ПолучитьНаименованиеВалюты(Объект.ВалютаРасхода);
		Текст3 = "(доход " + КодСчетаРасхода + "): " + Строка(СуммаКР) + " сом";	
		
		// Приход валюты, убыток	
	ИначеЕсли СчетУчетаВалютный(СчетПрихода) И НЕ СчетУчетаВалютный(СчетРасхода) И СуммаКР < 0 Тогда
		Текст2 = "Курс НБКР " + СокрЛП(Строка(КурсПрихода)) + " сом/" + ПолучитьНаименованиеВалюты(Объект.ВалютаПрихода);
		Текст3 = "(убыток " + КодСчетаПрихода + "): " + Строка(-СуммаКР) + " сом";		
		
		// Приход валюты, доход	
	ИначеЕсли СчетУчетаВалютный(СчетПрихода) И НЕ СчетУчетаВалютный(СчетРасхода) И СуммаКР > 0 Тогда
		Текст2 = "Курс НБКР " + СокрЛП(Строка(КурсПрихода)) + " сом/" + ПолучитьНаименованиеВалюты(Объект.ВалютаПрихода);
		Текст3 = "(доход " + КодСчетаПрихода + "): " + Строка(+СуммаКР) + " сом";
		
		// Валюта - Валюта, убыток	
	ИначеЕсли СчетУчетаВалютный(СчетПрихода) И СчетУчетаВалютный(СчетРасхода) И КурсПрихода < КурсРасхода Тогда
		Текст2 = "Кросскурс НБКР " + Объект.КросскурсНБКР + " " + ПолучитьНаименованиеВалюты(Объект.ВалютаПрихода) + "/" + ПолучитьНаименованиеВалюты(Объект.ВалютаРасхода);
		Текст3 = "(убыток " + КодСчетаРасхода + "): " + Строка(?(СуммаКР < 0, -СуммаКР, СуммаКР)) + " сом";			
		
		// Валюта - Валюта, доход		
	ИначеЕсли СчетУчетаВалютный(СчетПрихода) И СчетУчетаВалютный(СчетРасхода) И КурсПрихода > КурсРасхода Тогда
		Текст2 = "Кросскурс НБКР " + Объект.КросскурсНБКР + " " + ПолучитьНаименованиеВалюты(Объект.ВалютаРасхода) + "/" + ПолучитьНаименованиеВалюты(Объект.ВалютаПрихода);
		Текст3 = "(доход " + КодСчетаПрихода + "): " + Строка(?(СуммаКР < 0, -СуммаКР, СуммаКР)) + " сом";			
		
		// Сомы - Сомы	
	Иначе
		Текст2 = "";
		Текст3 = "";
	КонецЕсли;
	
	Элементы.КурсоваяРазница.Заголовок = Текст1 + Текст2 + ?(Текст2 = "", "", ". ") + ?(Текст3 = "", "", "Операционная КР ") + Текст3;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СчетУчетаВалютный(СчетУчета)	
	Возврат СчетУчета.Валютный;	
КонецФункции

&НаСервереБезКонтекста
Функция РасчетныйСчетПриИзмененииНаСервере(РасчетныйСчет)
	СтруктураРасчетныйСчет = Новый Структура;
	СтруктураРасчетныйСчет.Вставить("СчетУчета", 				РасчетныйСчет.СчетУчета);
	СтруктураРасчетныйСчет.Вставить("ВалютаДенежныхСредств", 	РасчетныйСчет.ВалютаДенежныхСредств);
	Возврат СтруктураРасчетныйСчет;
	
КонецФункции

&НаКлиенте
Процедура ПересчетКурсаОбмена()
	Если Объект.КурсРасхода >= Объект.КурсПрихода Тогда
		Объект.ПрямойКурс 		= Ложь;	
		Объект.КурсОбмена 		= Окр(Объект.КурсРасхода / Объект.КурсПрихода, 4);
		Объект.КросскурсНБКР 	= Объект.КурсОбмена;
	Иначе	
		Объект.ПрямойКурс 		= Истина;	
		Объект.КурсОбмена 		= Окр(Объект.КурсПрихода / Объект.КурсРасхода, 4);
		Объект.КросскурсНБКР 	= Объект.КурсОбмена;	
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПересчетКурсовойРазницы()

	Объект.СуммаКР = Объект.СуммаПрихода * Объект.КурсПрихода - Объект.СуммаРасхода * Объект.КурсРасхода;
	ПоказатьКР();

КонецПроцедуры // ПересчетКурсовойРазницы()

&НаКлиенте
Процедура ПоказатьКурсПрихода()

	Если ЗначениеЗаполнено(Объект.ВалютаПрихода) И ЗначениеЗаполнено(Объект.КурсПрихода) Тогда
		Элементы.ДекорацияКурсПрихода.Заголовок = Строка(Объект.КурсПрихода) + " сом/" + ПолучитьНаименованиеВалюты(Объект.ВалютаПрихода);	
	КонецЕсли;

КонецПроцедуры // ПоказатьКурсПрихода()

&НаКлиенте
Процедура ПоказатьКурсРасхода()

	Если ЗначениеЗаполнено(Объект.ВалютаРасхода) И ЗначениеЗаполнено(Объект.КурсРасхода) Тогда
		Элементы.ДекорацияКурсРасхода.Заголовок = Строка(Объект.КурсРасхода) + " сом/" + ПолучитьНаименованиеВалюты(Объект.ВалютаРасхода);	
	КонецЕсли;

КонецПроцедуры // ПоказатьКурсПрихода()

&НаКлиенте
Процедура ПриИзмененииСуммы()
	Если Объект.СуммаПрихода > Объект.СуммаРасхода Тогда
		Если ЗначениеЗаполнено(Объект.СуммаРасхода) Тогда
			Объект.КурсОбмена = Окр(Объект.СуммаПрихода / Объект.СуммаРасхода, 2);
		КонецЕсли;		
	Иначе
		Если ЗначениеЗаполнено(Объект.СуммаПрихода) Тогда
			Объект.КурсОбмена = Окр(Объект.СуммаРасхода / Объект.СуммаПрихода, 2);
		КонецЕсли;		
	КонецЕсли;
	ПересчетРасчетногоКурса();
КонецПроцедуры // ПриИзмененииСуммы()

&НаКлиенте
Процедура ПересчетРасчетногоКурса()
	Если Объект.СуммаПрихода = 0 Тогда
		Объект.КурсРасчетный = 0;	
	Иначе
		Объект.КурсРасчетный = Окр(Объект.СуммаРасхода * Объект.КурсРасхода / Объект.СуммаПрихода, 4);	
	КонецЕсли;		
	ПоказатьКурсПрихода();
	
КонецПроцедуры // ПересчетРасчетногоКурса()

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
