﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ВосстановитьПериодичностьКалендаря();
	ЦветаВидовДней = Новый ФиксированноеСоответствие(ЦветаОформленияВидовДнейПроизводственногоКалендаря());
	
	ЗаполнитьДаннымиТекущегоГода();
	ПреобразоватьДанныеПроизводственногоКалендаря();
	
	// заполнение реквизитов формы
	ПериодВДняхЗаполения = Периодичность.Количество();
	
	РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(ДанныеПроизводственногоКалендаря, "ГрафикРаботы", Объект.Ссылка);
	РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(ДанныеПроизводственногоКалендаря, "Год", НомерТекущегоГода);
	
	СписокВидовДня = Справочники.ГрафикиРаботы.СписокВидовДня();
	
	// получение данных о заполненых годах	
	ОбновлениеДанныхПоЗаполненымГодам();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода НомерТекущегоГода.
//
&НаКлиенте
Процедура НомерТекущегоГодаПриИзменении(Элемент)
	
	РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(ДанныеПроизводственногоКалендаря, "Год", НомерТекущегоГода);
	ПреобразоватьДанныеПроизводственногоКалендаря();
	
	ЗаполнитьДаннымиТекущегоГода();
	
	Элементы.ГрафикРаботы.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ГрафикРаботыПриВыводеПериода(Элемент, ОформлениеПериода)
	Для Каждого СтрокаОформленияПериода Из ОформлениеПериода.Даты Цикл
		ЦветОформленияДня = ЦветаВидовДней.Получить(ВидыДней.Получить(СтрокаОформленияПериода.Дата));
		Если ЦветОформленияДня = Неопределено Тогда
			ЦветОформленияДня = ОбщегоНазначенияКлиент.ЦветСтиля("ВидДняПроизводственногоКалендаряНеУказанЦвет");
		КонецЕсли;
		СтрокаОформленияПериода.ЦветТекста = ЦветОформленияДня;
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикРаботыПриАктивизацииДаты(Элемент)
	ВыделенныеДаты = Элемент.ВыделенныеДаты;
	
	Если НЕ ЗначениеЗаполнено(ВыделенныеДаты) Тогда 
		Возврат
	КонецЕсли;	
	
	НормаДнейМесяца = НормаДней.Получить(НачалоМесяца(Элемент.ВыделенныеДаты[0]));
	НормаЧасовМесяца = НормаЧасов.Получить(НачалоМесяца(Элемент.ВыделенныеДаты[0]));
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Периодичность.
//
&НаКлиенте
Процедура ПериодичностьПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элемент.ТекущиеДанные;
	ИзменитьЗапистьПериодичностьКалендаря(Новый Структура("Дата, Часы, ВидДня", СтрокаТабличнойЧасти.Дата, СтрокаТабличнойЧасти.Часы, СтрокаТабличнойЧасти.ВидДня));
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ДанныеПроизводственногоКалендаря.
//
&НаКлиенте
Процедура ДанныеПроизводственногоКалендаряПриИзменении(Элемент)
	ПреобразоватьДанныеПроизводственногоКалендаря();
	Элементы.ГрафикРаботы.Обновить();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПериодичность

// Процедура - обработчик события ПриИзменении поля ввода ПериодичностьВидДня.
//
&НаКлиенте
Процедура ПериодичностьВидДняПриИзменении(Элемент)
	// получаем текущую строку
	СтрокаТабличнойЧасти = Элементы.Периодичность.ТекущиеДанные;
	
	// не удалось получить- возвращаемся
	Если СтрокаТабличнойЧасти = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	СтрокаТабличнойЧасти.Часы = ?(СтрокаТабличнойЧасти.ВидДня = ПредопределенноеЗначение("Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий"), Объект.НормаЧасовЗаполнения, 0);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПериодичность(Команда)
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстСообщения = НСтр("ru = 'Элемент справочника еще не записан.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;	
	Ошибки = Неопределено;

	Если НЕ ЗначениеЗаполнено(НомерТекущегоГода) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнено поле ""Год заполнения""! Заполнение справочника отменено.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,	"НомерТекущегоГода", ТекстСообщения, Неопределено);
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ПериодВДняхЗаполения) Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнено поле ""Период в днях""!  Заполнение справочника отменено.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,	"ПериодВДняхЗаполения", ТекстСообщения, Неопределено);
	КонецЕсли;	
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если Отказ Тогда 
		Возврат
	КонецЕсли;	
	
	Если Периодичность.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличнуюЧасть", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличная часть справочника будет очищена! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ЗаполнитьТабличнуюЧастьНаКлиенте();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьКалендарь(Команда)
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстСообщения = НСтр("ru = 'Элемент справочника еще не записан.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;	
	Ошибки = Неопределено;

	Если НЕ ЗначениеЗаполнено(НомерТекущегоГода) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнено поле ""Год заполнения""! Заполнение справочника отменено.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,	"НомерТекущегоГода", ТекстСообщения, Неопределено);
	КонецЕсли;

	Если Периодичность.Количество() = 0 Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнен список ""Периодичность""!  Заполнение справочника отменено.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,	"Периодичность", ТекстСообщения, Неопределено);
	КонецЕсли;	
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	Если Отказ Тогда 
		Возврат
	КонецЕсли;	
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьДанныеПроизводственногоКалендаря", ЭтотОбъект);
	ТекстВопроса = НСтр("ru = 'Данные производственного каледаря будут перезаписаны! Продолжить выполнение операции?'");
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоШаблону(Команда)
	
	ЗаполнитьПоШаблонуНаСервере();
	
	Элементы.ГрафикРаботы.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьДень(Команда)
	
	ВыделенныеДаты = Элементы.ГрафикРаботы.ВыделенныеДаты;
	
	Если ВыделенныеДаты.Количество() > 0 И Год(ВыделенныеДаты[0]) = НомерТекущегоГода Тогда
		Оповещение = Новый ОписаниеОповещения("ИзменитьДеньЗавершение", ЭтотОбъект, ВыделенныеДаты);
		ПоказатьВыборИзСписка(Оповещение, СписокВидовДня, , СписокВидовДня.НайтиПоЗначению(ВидыДней.Получить(ВыделенныеДаты[0])));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьТабличнуюЧасть(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Периодичность.Очистить();
		ЗаполнитьТабличнуюЧастьНаКлиенте();
	КонецЕсли; 
КонецПроцедуры	

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьДанныеПроизводственногоКалендаря(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьДанныеПроизводственногоКалендаря();
		РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(ДанныеПроизводственногоКалендаря, "ГрафикРаботы", Объект.Ссылка);
		РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(ДанныеПроизводственногоКалендаря, "Год", НомерТекущегоГода);
		ПреобразоватьДанныеПроизводственногоКалендаря();		
		Элементы.ГрафикРаботы.Обновить();
	КонецЕсли; 
КонецПроцедуры	

&НаКлиенте
Процедура ИзменитьДеньЗавершение(ВыбранныйЭлемент, ВыделенныеДаты) Экспорт
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ИзменитьВидыДней(ВыделенныеДаты, ВыбранныйЭлемент.Значение);
		ПреобразоватьДанныеПроизводственногоКалендаря();		
		Элементы.ГрафикРаботы.Обновить();
		Элементы.ДанныеПроизводственногоКалендаря.Обновить();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура - Заполнить табличную часть на клиенте
//
&НаКлиенте
Процедура ЗаполнитьТабличнуюЧастьНаКлиенте()
	
	ДеньНачалоЗаполнения = Дата(НомерТекущегоГода, 1 , 1);
	ДеньОкончаниеЗаполнения	= ДеньНачалоЗаполнения + ПериодВДняхЗаполения * 86400;
	
	Пока ДеньНачалоЗаполнения < ДеньОкончаниеЗаполнения Цикл
		СтрокаТабличнойЧасти = Периодичность.Добавить();
		СтрокаТабличнойЧасти.Дата = ДеньНачалоЗаполнения; 
		СтрокаТабличнойЧасти.ВидДня = ОпределитьТипДеняНедели(СтрокаТабличнойЧасти.Дата);	
		СтрокаТабличнойЧасти.Часы = ?(СтрокаТабличнойЧасти.ВидДня = ПредопределенноеЗначение("Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий"),Объект.НормаЧасовЗаполнения, 0);
		
		ДеньНачалоЗаполнения = ДеньНачалоЗаполнения + 86400;
	КонецЦикла;
	
	ЗаполнитьПериодичностьКалендаря();	
КонецПроцедуры // ЗаполнитьТабличнуюЧастьНаКлиенте()

&НаСервере
Процедура ЗаполнитьПериодичностьКалендаря()

	// набор записей
	НаборЗаписей = РегистрыСведений.ПериодичностьКалендаря.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ГрафикРаботы.Установить(Объект.Ссылка);
	НаборЗаписей.Отбор.Год.Установить(НомерТекущегоГода);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();

	Для Каждого СтрокаТабличнойЧасти Из Периодичность Цикл
		Запись = НаборЗаписей.Добавить();
		Запись.ГрафикРаботы = Объект.Ссылка;
		Запись.Год = НомерТекущегоГода;
		Запись.Дата = СтрокаТабличнойЧасти.Дата;    
		Запись.ВидДня = СтрокаТабличнойЧасти.ВидДня;    
		Запись.Часы = СтрокаТабличнойЧасти.Часы;    
	КонецЦикла;	
	
	Попытка
		НаборЗаписей.Записать();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры // ЗаполнитьПериодичностьКалендаря()

&НаСервере
Процедура ВосстановитьПериодичностьКалендаря()
	Периодичность.Очистить();
	
	// набор записей
	НаборЗаписей = РегистрыСведений.ПериодичностьКалендаря.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ГрафикРаботы.Установить(Объект.Ссылка);
	НаборЗаписей.Отбор.Год.Установить(НомерТекущегоГода);
	НаборЗаписей.Прочитать();

	Для Каждого Запись Из НаборЗаписей Цикл
		СтрокаТабличнойЧасти = Периодичность.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, Запись);
	КонецЦикла;	
КонецПроцедуры // ВосстановитьПериодичностьКалендаря()

&НаСервере
Процедура ИзменитьЗапистьПериодичностьКалендаря(ДанныеПериодичности)

	// набор записей
	НаборЗаписей = РегистрыСведений.ПериодичностьКалендаря.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ГрафикРаботы.Установить(Объект.Ссылка);
	НаборЗаписей.Отбор.Год.Установить(НомерТекущегоГода);
	НаборЗаписей.Отбор.Дата.Установить(ДанныеПериодичности.Дата);
	НаборЗаписей.Прочитать();

	Для Каждого Запись Из НаборЗаписей Цикл 
		Запись.ВидДня = ДанныеПериодичности.ВидДня;    
		Запись.Часы = ДанныеПериодичности.Часы;    
	КонецЦикла;	
	
	Попытка
		НаборЗаписей.Записать();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры // ИзменитьЗапистьПериодичностьКалендаря()

// Процедура - Заполнить данные производственного календаря
//
&НаСервере
Процедура ЗаполнитьДанныеПроизводственногоКалендаря()
	
	// набор записей
	НаборЗаписей = РегистрыСведений.ДанныеПроизводственногоКалендаря.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ГрафикРаботы.Установить(Объект.Ссылка);
	НаборЗаписей.Отбор.Год.Установить(НомерТекущегоГода);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();

	// учет праздничных дней
	МассивПраздничныхДней = Новый Массив;
	МассивПредПраздничныхДней = Новый Массив;
	
	Если Объект.УчитыватьПраздники Тогда
		МассивПраздничныхДней.Добавить("0101"); //, "Новый год");
		МассивПраздничныхДней.Добавить("0107"); //, "Православное Рождество");
		МассивПраздничныхДней.Добавить("0223"); //, "День защитника  Отечества");
		МассивПраздничныхДней.Добавить("0308"); //, "Международный женский день");
		МассивПраздничныхДней.Добавить("0321"); //, "Народный праздник Нооруз");
		МассивПраздничныхДней.Добавить("0501"); //, "День международной солидарности");
		МассивПраздничныхДней.Добавить("0505"); //, "День Конституции");  
		МассивПраздничныхДней.Добавить("0509"); //, "День Победы");
		МассивПраздничныхДней.Добавить("0831"); //, "День Государственной независимости Кыргызской Республики");
		МассивПраздничныхДней.Добавить("1107"); //, "День примирения");
		
		МассивПредПраздничныхДней.Добавить("1231");
		МассивПредПраздничныхДней.Добавить("0106");
		МассивПредПраздничныхДней.Добавить("0222");
		МассивПредПраздничныхДней.Добавить("0307");
		МассивПредПраздничныхДней.Добавить("0320");
		МассивПредПраздничныхДней.Добавить("0430");
		МассивПредПраздничныхДней.Добавить("0504");  
		МассивПредПраздничныхДней.Добавить("0508");
		МассивПредПраздничныхДней.Добавить("0830");
		МассивПредПраздничныхДней.Добавить("1106");
	КонецЕсли;	
	
	// заполнение данных производственного календаря
	ТекущаяДата 			= Дата(НомерТекущегоГода,1,1);
	ДатаОкончанияИнтервала 	= Дата(НомерТекущегоГода,12,31);
	
	ВидДняРабочий = ПредопределенноеЗначение("Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий");
	ВидДняПраздник = ПредопределенноеЗначение("Перечисление.ВидыДнейПроизводственногоКалендаря.Праздник");
	ВидДняПредпраздничный = ПредопределенноеЗначение("Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный");
	
	Пока ТекущаяДата <= ДатаОкончанияИнтервала Цикл
		Для Каждого СтрокаТабличнойЧасти Из Периодичность Цикл
			Если ТекущаяДата > ДатаОкончанияИнтервала Тогда 
				Прервать;
			КонецЕсли;	
				
			// определение праздничного дня
			ПраздничныйДень = МассивПраздничныхДней.Найти(Формат(ТекущаяДата, "ДФ=MMdd"));
			ПредПраздничныйДень = МассивПредПраздничныхДней.Найти(Формат(ТекущаяДата, "ДФ=MMdd"));
			
			Запись = НаборЗаписей.Добавить();
			Запись.ГрафикРаботы = Объект.Ссылка;
			Запись.Год = НомерТекущегоГода;
			Запись.Дата = ТекущаяДата;    
			
			Запись.ЗначениеДней = ?(ПраздничныйДень = Неопределено И СтрокаТабличнойЧасти.ВидДня = ВидДняРабочий, 1, 0);
			Запись.ЗначениеЧасов = ?(ПраздничныйДень = Неопределено И СтрокаТабличнойЧасти.ВидДня = ВидДняРабочий, СтрокаТабличнойЧасти.Часы, 0); 
			Запись.ВидДня = ?(ПраздничныйДень = Неопределено И ПредПраздничныйДень = Неопределено, СтрокаТабличнойЧасти.ВидДня, 
							?(ПраздничныйДень = Неопределено, ВидДняПредпраздничный, ВидДняПраздник)); 
			
			ТекущаяДата = ТекущаяДата + 86400;
		КонецЦикла;	
	КонецЦикла;
	
	Попытка
		НаборЗаписей.Записать();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
	
	ОбновлениеДанныхПоЗаполненымГодам();
КонецПроцедуры // ЗаполнитьДанныеПроизводственногоКалендаря()

&НаКлиенте
// Функция возвращает наименование вида дня недели по его номеру
//
// Параметры:
//  Дата - Дата	- дата для получения вида дня
// Возвращаемое значение:
//  Перечисление.ВидыДнейПроизводственногоКалендаря - вид дня
//    
Функция ОпределитьТипДеняНедели(Дата) 
	
	ВидДня = ПредопределенноеЗначение("Перечисление.ВидыДнейПроизводственногоКалендаря.ПустаяСсылка");
	
	НомерДняНедели = ДеньНедели(Дата);
	
	Если НомерДняНедели = 1 Тогда
		ВидДня = ПредопределенноеЗначение("Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий");
	ИначеЕсли НомерДняНедели = 2 Тогда
		ВидДня = ПредопределенноеЗначение("Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий");
	ИначеЕсли НомерДняНедели = 3 Тогда
		ВидДня = ПредопределенноеЗначение("Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий");
	ИначеЕсли НомерДняНедели = 4 Тогда
		ВидДня = ПредопределенноеЗначение("Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий");
	ИначеЕсли НомерДняНедели = 5 Тогда
		ВидДня = ПредопределенноеЗначение("Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий");
	ИначеЕсли НомерДняНедели = 6 Тогда
		ВидДня = ПредопределенноеЗначение("Перечисление.ВидыДнейПроизводственногоКалендаря.Суббота");
	ИначеЕсли НомерДняНедели = 7 Тогда
		ВидДня = ПредопределенноеЗначение("Перечисление.ВидыДнейПроизводственногоКалендаря.Воскресенье");
	КонецЕсли;
	
	Возврат	ВидДня;
КонецФункции

&НаСервере
Процедура ЗаполнитьПоШаблонуНаСервере(СохранятьРучноеРедактирование = Ложь)

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДаннымиТекущегоГода()
	
	// Заполняет форму данными текущего года.
	НастроитьПолеКалендаря();
	
	// Восстановить Периодичность
	ВосстановитьПериодичностьКалендаря();
КонецПроцедуры

&НаСервере
Процедура НастроитьПолеКалендаря()
	
	Если НомерТекущегоГода = 0 Тогда
		НомерТекущегоГода = Год(ТекущаяДатаСеанса());
	КонецЕсли;
	
	ГрафикРаботы = Дата(НомерТекущегоГода, 1, 1);
	Элементы.ГрафикРаботы.НачалоПериодаОтображения	= Дата(НомерТекущегоГода, 1, 1);
	Элементы.ГрафикРаботы.КонецПериодаОтображения	= Дата(НомерТекущегоГода, 12, 31);
		
КонецПроцедуры

// Функция определяет соответствие видов дня производственного календаря и цвета оформления
// этого дня в поле календаря.
//
// Возвращаемое значение
//	ЦветаОформления - соответствие видов дня и цветов оформления.
//
Функция ЦветаОформленияВидовДнейПроизводственногоКалендаря() Экспорт
	
	ЦветаОформления = Новый Соответствие;
	
	ЦветаОформления.Вставить(Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий,			ЦветаСтиля.ВидДняПроизводственногоКалендаряРабочийЦвет);
	ЦветаОформления.Вставить(Перечисления.ВидыДнейПроизводственногоКалендаря.Суббота,			ЦветаСтиля.ВидДняПроизводственногоКалендаряСубботаЦвет);
	ЦветаОформления.Вставить(Перечисления.ВидыДнейПроизводственногоКалендаря.Воскресенье,		ЦветаСтиля.ВидДняПроизводственногоКалендаряВоскресеньеЦвет);
	ЦветаОформления.Вставить(Перечисления.ВидыДнейПроизводственногоКалендаря.Предпраздничный,	ЦветаСтиля.ВидДняПроизводственногоКалендаряПредпраздничныйЦвет);
	ЦветаОформления.Вставить(Перечисления.ВидыДнейПроизводственногоКалендаря.Праздник,			ЦветаСтиля.ВидДняПроизводственногоКалендаряПраздникЦвет);
	ЦветаОформления.Вставить(Перечисления.ВидыДнейПроизводственногоКалендаря.Выходной,			ЦветаСтиля.ВидДняПроизводственногоКалендаряПраздникЦвет);
	
	Возврат ЦветаОформления;
	
КонецФункции

&НаСервере
Процедура ПреобразоватьДанныеПроизводственногоКалендаря()
	
	// Данные производственного календаря используются в форме 
	// в виде соответствий ВидыДней.
	// Процедура заполняет эти соответствия.
	
	ВидыДнейСоответствие = Новый Соответствие;
	НормаДнейСоответствие = Новый Соответствие;
	НормаЧасовСоответствие = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДанныеПроизводственногоКалендаря.Дата,
		|	ДанныеПроизводственногоКалендаря.ВидДня,
		|	ДанныеПроизводственногоКалендаря.ЗначениеДней,
		|	ДанныеПроизводственногоКалендаря.ЗначениеЧасов
		|ПОМЕСТИТЬ ВременнаяТаблицаДанныеПроизводственногоКалендаря
		|ИЗ
		|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
		|ГДЕ
		|	ДанныеПроизводственногоКалендаря.ГрафикРаботы = &ГрафикРаботы
		|	И ДанныеПроизводственногоКалендаря.Год = &Год
		|	И ДанныеПроизводственногоКалендаря.Дата МЕЖДУ &НачалоПериода И &КонецПериода
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаДанныеПроизводственногоКалендаря.Дата,
		|	ВременнаяТаблицаДанныеПроизводственногоКалендаря.ВидДня
		|ИЗ
		|	ВременнаяТаблицаДанныеПроизводственногоКалендаря КАК ВременнаяТаблицаДанныеПроизводственногоКалендаря
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НАЧАЛОПЕРИОДА(ВременнаяТаблицаДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ) КАК Месяц,
		|	СУММА(ВременнаяТаблицаДанныеПроизводственногоКалендаря.ЗначениеДней) КАК ЗначениеДней,
		|	СУММА(ВременнаяТаблицаДанныеПроизводственногоКалендаря.ЗначениеЧасов) КАК ЗначениеЧасов
		|ИЗ
		|	ВременнаяТаблицаДанныеПроизводственногоКалендаря КАК ВременнаяТаблицаДанныеПроизводственногоКалендаря
		|
		|СГРУППИРОВАТЬ ПО
		|	НАЧАЛОПЕРИОДА(ВременнаяТаблицаДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ)";
	Запрос.УстановитьПараметр("Год", НомерТекущегоГода);
	Запрос.УстановитьПараметр("ГрафикРаботы", Объект.Ссылка);
	Запрос.УстановитьПараметр("НачалоПериода", Дата(НомерТекущегоГода, 1, 1));
	Запрос.УстановитьПараметр("КонецПериода", Дата(НомерТекущегоГода, 12, 31));
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаДетальныеЗаписи = МассивРезультатов[1].Выбрать();	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ВидыДнейСоответствие.Вставить(ВыборкаДетальныеЗаписи.Дата, ВыборкаДетальныеЗаписи.ВидДня);
	КонецЦикла;
	
	НормаДнейМесяца = 0;
	НормаЧасовМесяца = 0;
	
	ВыборкаДетальныеЗаписи = МассивРезультатов[2].Выбрать();	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НормаДнейСоответствие.Вставить(ВыборкаДетальныеЗаписи.Месяц, ВыборкаДетальныеЗаписи.ЗначениеДней);
		НормаЧасовСоответствие.Вставить(ВыборкаДетальныеЗаписи.Месяц, ВыборкаДетальныеЗаписи.ЗначениеЧасов);
	КонецЦикла;
	
	ВидыДней = Новый ФиксированноеСоответствие(ВидыДнейСоответствие);
	НормаДней = Новый ФиксированноеСоответствие(НормаДнейСоответствие);
	НормаЧасов = Новый ФиксированноеСоответствие(НормаЧасовСоответствие);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВидыДней(ДатыДней, ВидДня)
	
	// Устанавливает дням по всем датам массива определенный вид.
	ВидыДнейСоответствие = Новый Соответствие(ВидыДней);
	
	Для Каждого ВыбраннаяДата Из ДатыДней Цикл
		ВидыДнейСоответствие.Вставить(ВыбраннаяДата, ВидДня);
	КонецЦикла;
	
	ВидыДней = Новый ФиксированноеСоответствие(ВидыДнейСоответствие);
	
	// Изменить ДанныеПроизводственногоКалендаря
	ИзменитьВидыДнейДанныеПроизводственногоКалендаря(Объект.Ссылка, НомерТекущегоГода, Объект.НормаЧасовЗаполнения, ДатыДней, ВидДня);
КонецПроцедуры

// Процедура - Изменить виды дней данные производственного календаря
//
// Параметры:
//  ГрафикРаботы		 - 									 - 
//  НомерТекущегоГода	 - 									 - 
//  НормаЧасов			 - 									 - 
//  ДатыДней			 - Массив							 - 
//  ВидДня				 - Перечисление.ВидыДнейПроизводственногоКалендаря	 - 
//  	  
&НаСервереБезКонтекста
Процедура ИзменитьВидыДнейДанныеПроизводственногоКалендаря(ГрафикРаботы, НомерТекущегоГода, НормаЧасовЗаполнения, ДатыДней, ВидДня)
	// набор записей
	НаборЗаписей = РегистрыСведений.ДанныеПроизводственногоКалендаря.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ГрафикРаботы.Установить(ГрафикРаботы);
	НаборЗаписей.Отбор.Год.Установить(НомерТекущегоГода);
	
	ВидДняРабочий = ПредопределенноеЗначение("Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий");
	
	Для Каждого ДатаДня Из ДатыДней Цикл 
		НаборЗаписей.Отбор.Дата.Установить(ДатаДня);
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() = 0 Тогда 
			Продолжить;
		КонецЕсли;	
		
		Для Каждого Запись Из НаборЗаписей Цикл 
			Запись.ВидДня = ВидДня;
			Запись.ЗначениеДней = ?(ВидДня = ВидДняРабочий, 1, 0);
			Запись.ЗначениеЧасов = ?(ВидДня = ВидДняРабочий, НормаЧасовЗаполнения, 0); 
		КонецЦикла;	
		
		НаборЗаписей.Записать();
	КонецЦикла;	
	
КонецПроцедуры // ИзменитьДанныеПроизводственногоКалендаря()

// <Описание процедуры>
&НаСервере
Процедура ОбновлениеДанныхПоЗаполненымГодам()

	ЗаполненныеГода = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДанныеПроизводственногоКалендаря.Год
		|ИЗ
		|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
		|ГДЕ
		|	ДанныеПроизводственногоКалендаря.ГрафикРаботы = &ГрафикРаботы
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеПроизводственногоКалендаря.Год";
	Запрос.УстановитьПараметр("ГрафикРаботы", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗаполненныеГода = ЗаполненныеГода + СтрЗаменить(ВыборкаДетальныеЗаписи.Год, Символы.НПП,"") + ";";	
	КонецЦикла;
	
КонецПроцедуры // ОбновлениеДанныхПоЗаполненымГодам()

#КонецОбласти
