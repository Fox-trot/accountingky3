﻿//////////////////////////////////////////////////////////////////////////////// 
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ 

// Выводит сообщение об ошибке заполнения поля.
//
Процедура СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения, ИмяТабличнойЧасти = Неопределено, НомерСтроки = Неопределено, Поле = Неопределено, Отказ = Ложь) Экспорт
	
	Сообщение = Новый СообщениеПользователю();
	Сообщение.Текст = ТекстСообщения;
	
	Если ИмяТабличнойЧасти <> Неопределено Тогда
		Сообщение.Поле = ИмяТабличнойЧасти + "[" + (НомерСтроки - 1) + "]." + Поле;
	ИначеЕсли ЗначениеЗаполнено(Поле) Тогда
		Сообщение.Поле = Поле;
	КонецЕсли;
	
	Если ЭтотОбъект <> Неопределено Тогда
		Сообщение.УстановитьДанные(ЭтотОбъект);
	КонецЕсли;
	
	Сообщение.Сообщить();
	
	Отказ = Истина;
	
КонецПроцедуры // СообщитьОбОшибке()

// ПРОЦЕДУРЫ И ФУНКЦИИ УПРАВЛЕНИЯ ПЕЧАТЬЮ

// Функция формирует заголовок для общей формы "Печать".
// ПараметрКоманды - параметр команды печати.
//
Функция ПолучитьЗаголовокПечатнойФормы(ПараметрКоманды) Экспорт 
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") 
		И ПараметрКоманды.Количество() = 1 Тогда 
		
		Возврат Новый Структура("ЗаголовокФормы", ПараметрКоманды[0]);
		
	КонецЕсли;

	Возврат Неопределено;
	
КонецФункции // ПолучитьЗаголовокПечатнойФормы()

// ПРОЦЕДУРЫ ДЛЯ РАБОТЫ С ПОДЧИНЕННЫМИ ТАБЛИЧНЫМИ ЧАСТЯМИ

// Процедура добавляет ключ связи в табличную часть.
//
// Параметры:
//  ФормаДокумента - УправляемаяФорма, содержит форму документа, реквизиты
//                 которой обрабатываются процедурой
//
Процедура ДобавитьКлючСвязиВСтрокуТабличнойЧасти(ФормаДокумента, ИмяКлючСвязи = "КлючСвязи") Экспорт

	СтрокаТабличнойЧасти = ФормаДокумента.Элементы[ФормаДокумента.ИмяТабличнойЧасти].ТекущиеДанные;
    
	СтрокаТабличнойЧасти[ИмяКлючСвязи] = СоздатьНовыйКлючСвязи(ФормаДокумента, ИмяКлючСвязи);		
        
КонецПроцедуры // ДобавитьКлючСвязиВСтрокуТабличнойЧасти()

// Процедура добавляет ключ связи в подчиненную табличную часть.
//
// Параметры:
//  ФормаДокумента - УправляемаяФорма, содержит форму документа, реквизиты
//                 которой обрабатываются процедурой
//	ИмяПодчиненнойТабличнойЧасти - Строка, содержащая имя подчиненной табличной
//                 части.
//
Процедура ДобавитьКлючСвязиВСтрокуПодчиненнойТабличнойЧасти(ФормаДокумента, ИмяПодчиненнойТабличнойЧасти, ИмяКлючСвязи = "КлючСвязи") Экспорт
	
	ПодчиненнаяТабличнаяЧасть = ФормаДокумента.Элементы[ИмяПодчиненнойТабличнойЧасти];
	
	СтрокаПодчиненнойТабличнойЧасти = ПодчиненнаяТабличнаяЧасть.ТекущиеДанные;
	СтрокаПодчиненнойТабличнойЧасти[ИмяКлючСвязи] = ПодчиненнаяТабличнаяЧасть.ОтборСтрок[ИмяКлючСвязи];
	
	СтрОтбора = Новый ФиксированнаяСтруктура(ИмяКлючСвязи, ПодчиненнаяТабличнаяЧасть.ОтборСтрок[ИмяКлючСвязи]);
	ФормаДокумента.Элементы[ИмяПодчиненнойТабличнойЧасти].ОтборСтрок = СтрОтбора;

КонецПроцедуры // ДобавитьКлючСвязиВСтрокуПодчиненнойТабличнойЧасти()

// Процедура запрещает добавление новой строки, если не выбрана строка в основной табличной части.
//
// Параметры:
//  ФормаДокумента - УправляемаяФорма, содержит форму документа, реквизиты
//                 которой обрабатываются процедурой
//	ИмяПодчиненнойТабличнойЧасти - Строка, содержащая имя подчиненной табличной
//                 части.
//
Функция ПередНачаломДобавленияВПодчиненнуюТабличнуюЧасть(ФормаДокумента, ИмяПодчиненнойТабличнойЧасти) Экспорт

	Если ФормаДокумента.Элементы[ФормаДокумента.ИмяТабличнойЧасти].ТекущиеДанные = Неопределено Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не выбрана строка основной табличной части!'");
		Сообщение.Сообщить();
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
		
КонецФункции // ПередНачаломДобавленияВПодчиненнуюТабличнуюЧасть()

// Процедура удаляет строки из подчиненной табличной части.
//
// Параметры:
//  ФормаДокумента - УправляемаяФорма, содержит форму документа, реквизиты
//                 которой обрабатываются процедурой
//	ИмяПодчиненнойТабличнойЧасти - Строка, содержащая имя подчиненной табличной
//                 части.
//
Процедура УдалитьСтрокиПодчиненнойТабличнойЧасти(ФормаДокумента, ИмяПодчиненнойТабличнойЧасти, ИмяКлючСвязи = "КлючСвязи") Экспорт

	СтрокаТабличнойЧасти = ФормаДокумента.Элементы[ФормаДокумента.ИмяТабличнойЧасти].ТекущиеДанные;
	ПодчиненнаяТабличнаяЧасть = ФормаДокумента.Объект[ИмяПодчиненнойТабличнойЧасти];
   	
    РезультатПоиска = ПодчиненнаяТабличнаяЧасть.НайтиСтроки(Новый Структура(ИмяКлючСвязи, СтрокаТабличнойЧасти[ИмяКлючСвязи]));
	Для каждого СтрокаПоиска Из  РезультатПоиска Цикл
		ИндексУдаления = ПодчиненнаяТабличнаяЧасть.Индекс(СтрокаПоиска);
		ПодчиненнаяТабличнаяЧасть.Удалить(ИндексУдаления);
	КонецЦикла;
	
КонецПроцедуры // УдалитьСтрокиПодчиненнойТабличнойЧасти()

// Процедура создает новый ключ связи для таблиц.
//
// Параметры:
//  ФормаДокумента - УправляемаяФорма, содержит форму документа, реквизиты
//                 которой обрабатываются процедурой.
//
Функция СоздатьНовыйКлючСвязи(ФормаДокумента, ИмяКлючСвязи = "КлючСвязи") Экспорт

	СписокЗначений = Новый СписокЗначений;
	
	ТабличнаяЧасть = ФормаДокумента.Объект[ФормаДокумента.ИмяТабличнойЧасти];
	Для каждого СтрокаТЧ Из ТабличнаяЧасть Цикл
        СписокЗначений.Добавить(СтрокаТЧ[ИмяКлючСвязи]);
	КонецЦикла;

    Если СписокЗначений.Количество() = 0 Тогда
		КлючСвязи = 1;
	Иначе
		СписокЗначений.СортироватьПоЗначению();
		КлючСвязи = СписокЗначений.Получить(СписокЗначений.Количество() - 1).Значение + 1;
	КонецЕсли;

	Возврат КлючСвязи;

КонецФункции //  СоздатьНовыйКлючСвязи()

// Процедура устанавливает отбор на подчиненную табличную часть.
//
Процедура УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ФормаДокумента, ИмяПодчиненнойТабличнойЧасти, ИмяКлючСвязи = "КлючСвязи") Экспорт
	
	СтрокаТабличнойЧасти = ФормаДокумента.Элементы[ФормаДокумента.ИмяТабличнойЧасти].ТекущиеДанные;
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	СтрОтбора = Новый ФиксированнаяСтруктура(ИмяКлючСвязи, ФормаДокумента.Элементы[ФормаДокумента.ИмяТабличнойЧасти].ТекущиеДанные[ИмяКлючСвязи]);
	ФормаДокумента.Элементы[ИмяПодчиненнойТабличнойЧасти].ОтборСтрок = СтрОтбора;
	
КонецПроцедуры //УстановитьОтборНаПодчиненнуюТабличнуюЧасть()

// ПРОЦЕДУРЫ И ФУНКЦИИ ПОДСИСТЕМЫ ЗУП

// Процедура устанавливает период регистрации на начало месяца.
// А так же обновляет надпись периода на форме
Процедура ПриИзмененииПериодаРегистрации(ПереданнаяФорма) Экспорт
	
	Если Найти(ПереданнаяФорма.ИмяФормы, "ЖурналДокументов") > 0 
		ИЛИ Найти(ПереданнаяФорма.ИмяФормы, "ФормаОтчета") Тогда
		ПереданнаяФорма.ПериодРегистрации 				= НачалоМесяца(ПереданнаяФорма.ПериодРегистрации);
		ПереданнаяФорма.ОтображениеПериодаРегистрации 	= Формат(ПереданнаяФорма.ПериодРегистрации, "ДФ='MMMM yyyy'");
	ИначеЕсли Найти(ПереданнаяФорма.ИмяФормы, "ФормаСписка") > 0 Тогда
		ПереданнаяФорма.ОтборПериодРегистрации 			= НачалоМесяца(ПереданнаяФорма.ОтборПериодРегистрации);
		ПереданнаяФорма.ОтображениеПериодаРегистрации 	= Формат(ПереданнаяФорма.ОтборПериодРегистрации, "ДФ='MMMM yyyy'");
	Иначе
		ПереданнаяФорма.Объект.ПериодРегистрации 		= НачалоМесяца(ПереданнаяФорма.Объект.ПериодРегистрации);
		ПереданнаяФорма.ОтображениеПериодаРегистрации 	= Формат(ПереданнаяФорма.Объект.ПериодРегистрации, "ДФ='MMMM yyyy'");
	КонецЕсли;
	
КонецПроцедуры

// Процедура выполняет приращение даты по кнопкам регулирования
// Используется в журнале и документах зарплаты, Расзод ДС из кассы, отчетах Расчетные листки
// Шаг равняется месяцу
//
// Параметры:
//   ПереданнаяФорма 	- форма, данные которой правятся
//   Направление 		- значение приращения, может быть положительным и отрицательным
Процедура ПриРегулированииПериодаРегистрации(ПереданнаяФорма, Направление) Экспорт
	
	Если Найти(ПереданнаяФорма.ИмяФормы, "ЖурналДокументов") > 0 
		ИЛИ Найти(ПереданнаяФорма.ИмяФормы, "ФормаОтчета") Тогда
		
		ПереданнаяФорма.ПериодРегистрации = ?(ЗначениеЗаполнено(ПереданнаяФорма.ПериодРегистрации), 
							ДобавитьМесяц(ПереданнаяФорма.ПериодРегистрации, Направление),
							ДобавитьМесяц(НачалоМесяца(ТекущаяДата()), Направление));
		
	ИначеЕсли Найти(ПереданнаяФорма.ИмяФормы, "ФормаСписка") > 0 Тогда
		
		ПереданнаяФорма.ОтборПериодРегистрации = ?(ЗначениеЗаполнено(ПереданнаяФорма.ОтборПериодРегистрации), 
							ДобавитьМесяц(ПереданнаяФорма.ОтборПериодРегистрации, Направление),
							ДобавитьМесяц(НачалоМесяца(ТекущаяДата()), Направление));
		
	Иначе
		
		ПереданнаяФорма.Объект.ПериодРегистрации = ?(ЗначениеЗаполнено(ПереданнаяФорма.Объект.ПериодРегистрации), 
							ДобавитьМесяц(ПереданнаяФорма.Объект.ПериодРегистрации, Направление),
							ДобавитьМесяц(НачалоМесяца(ТекущаяДата()), Направление));
		
	КонецЕсли;
	
КонецПроцедуры // ПриРегулированииПериодаРегистрации()

// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Функция пересчитывает сумму из одной валюты в другую
//
// Параметры:      
//	Сумма         - Число - сумма, которую следует пересчитать.
// 	КурсНач       - Число - курс из которого надо пересчитать.
// 	КурсКон       - Число - курс в который надо пересчитать.
// 	КратностьНач  - Число - кратность из которого надо пересчитать 
//                  (по умолчанию = 1).
// 	КратностьКон  - Число - кратность в который надо пересчитать 
//                  (по умолчанию = 1).
//
// Возвращаемое значение: 
//  Число - сумма, пересчитанная в другую валюту.
//
Функция ПересчитатьИзВалютыВВалюту(Сумма, КурсНач, КурсКон,	КратностьНач = 1, КратностьКон = 1) Экспорт
	
	Если (КурсНач = КурсКон) И (КратностьНач = КратностьКон) Тогда
		Возврат Сумма;
	КонецЕсли;
	
	Если КурсНач = 0 ИЛИ КурсКон = 0 ИЛИ КратностьНач = 0 ИЛИ КратностьКон = 0 Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = НСтр("ru = 'Обнаружен нулевой курс валюты. Пересчет не выполнен.'");
		Сообщение.Сообщить();
		Возврат Сумма;
	КонецЕсли;
	
	СуммаПересчитанная = Окр((Сумма * КурсНач * КратностьКон) / (КурсКон * КратностьНач), 2);
	
	Возврат СуммаПересчитанная;
	
КонецФункции // ПересчитатьИзВалютыВВалюту()

// Процедура добовляет дополнительную информацию к заголовку формы
//
// Форма- текущая форма
// Заголовок - строка
Процедура ОбновитьЗаголовокФормы(Форма, ТекстЗаголовок = "") Экспорт 
	Форма.Заголовок = ТекстЗаголовок;
КонецПроцедуры // ОбновитьЗаголовокФормы()

// Функция возвращает представление дня недели.
//
Функция ПолучитьПредставлениеДняНедели(ДеньНеделиКалендаря) Экспорт
	
	НомерДняНедели = ДеньНедели(ДеньНеделиКалендаря);
	Если НомерДняНедели = 1 Тогда
		
		Возврат НСтр("ru = 'Пн'");
		
	ИначеЕсли НомерДняНедели = 2 Тогда
		
		Возврат НСтр("ru = 'Вт'");
		
	ИначеЕсли НомерДняНедели = 3 Тогда
		
		Возврат НСтр("ru = 'Ср'");
		
	ИначеЕсли НомерДняНедели = 4 Тогда
		
		Возврат НСтр("ru = 'Чт'");
		
	ИначеЕсли НомерДняНедели = 5 Тогда
		
		Возврат НСтр("ru = 'Пт'");
		
	ИначеЕсли НомерДняНедели = 6 Тогда
		
		Возврат НСтр("ru = 'Сб'");
		
	Иначе
		
		Возврат НСтр("ru = 'Вс'");
		
	КонецЕсли;
	
КонецФункции // ПолучитьПредставлениеДняНедели()

// Заполняет структуру данных для открытии формы выбора календаря
//
Функция ПолучитьПараметрыОткрытияФормыКалендаря(ДатаКалендаряПриОткрытии, 
		ЗакрыватьПриВыборе = Истина, 
		МножественныйВыбор = Ложь) Экспорт
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить(
		"ДатаКалендаря", 
			ДатаКалендаряПриОткрытии
		);
		
	СтруктураПараметров.Вставить(
		"ЗакрыватьПриВыборе", 
			ЗакрыватьПриВыборе
		);
		
	СтруктураПараметров.Вставить(
		"МножественныйВыбор", 
			МножественныйВыбор
		);
		
	Возврат СтруктураПараметров;
	
КонецФункции // ПолучитьПараметрыОткрытияФормыКалендаря()

// Помещает переданное значение в СписокЗначений
// 
Функция ЗначениеВСписокЗначенийНаКлиенте(Значение, СписокЗначений = Неопределено, ДобавлятьДубликаты = Ложь) Экспорт
	
	Если ТипЗнч(СписокЗначений) = Тип("СписокЗначений") Тогда
		
		Если ДобавлятьДубликаты Тогда
			
			СписокЗначений.Добавить(Значение);
			
		ИначеЕсли СписокЗначений.НайтиПоЗначению(Значение) = Неопределено Тогда
			
			СписокЗначений.Добавить(Значение);
			
		КонецЕсли;
		
	Иначе
		
		СписокЗначений = Новый СписокЗначений;
		СписокЗначений.Добавить(Значение);
		
	КонецЕсли;
	
	Возврат СписокЗначений;
	
КонецФункции // ЗначениеВСписокЗначенийНаКлиенте()

///////////////////////////////////////////////////////////////////////////////// 
// ФУНКЦИИ ОБМЕНА С БАНКАМИ

Процедура ЗагрузитьДанныеИзФайлаВыпискиЗавершение(Успешно, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Успешно Тогда
		ДополнительныеПараметры.АдресВХранилище = Адрес;
		ДополнительныеПараметры.ПутьДоФайла1 = ВыбранноеИмяФайла;
		ЗагрузитьДанныеИзФайлаВыпискиФрагмент(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗагрузитьДанныеИзФайлаВыпискиФрагмент(ДополнительныеПараметры)
	
	Состояние(
		НСтр("ru = 'Загружается файл выписки'"),
		,
		НСтр("ru = 'В данный момент в разработке'"),
		БиблиотекаКартинок.ЗагрузкаДанных32
	);	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ РАБОТЫ СО СЧЕТАМИ И СУБКОНТО В ФОРМАХ И ЭЛЕМЕНТАХ УПРАВЛЕНИЯ

// Процедура открывает специализированные формы для субконто специфического типа,
// а так же устанавливает необходимые отборы в стандартных формах выбора
Процедура НачалоВыбораЗначенияСубконто(Форма, Элемент, СтандартнаяОбработка, СписокПараметров) Экспорт
	
	Если СписокПараметров.Свойство("СчетУчета") Тогда
		ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СписокПараметров.СчетУчета);
	ИначеЕсли СписокПараметров.Свойство("СчетБУ") Тогда
		ДанныеСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СписокПараметров.СчетБУ);
	КонецЕсли;
		
КонецПроцедуры


