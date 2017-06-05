﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеОбъектовБП.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

// Процедура - Заполняет ТЧ "Декларация".
//
Процедура ЗаполнитьТабличнуюЧасть() Экспорт
//Процедура ЗаполнитьСуммыНалоговойДекларации()
	
	ТЗСчетов = Новый ТаблицаЗначений;
	ВыборкаФормул = Неопределено;
	
	ПолучитьТаблицыКодовСтрокНалоговойДекларации(ТЗСчетов, ВыборкаФормул);
	
	ДатаДекларации  = НачалоГода(Дата);
		               
	УбытокОтКР = 0;	
	
	// Заполнение строк - первичное			
	Для Каждого СТЗ Из ТЗСчетов Цикл
		СтрокаЧислом = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(СТЗ.Строка);
		
		Если СтрокаЧислом = Неопределено Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'В регистре сведений ""Коды строк налоговой декларации"", за %1 год, не верно заполнена строка %2!'"), 
								Формат(Год(Дата), "ЧГ=0"), СТЗ.Строка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Продолжить;
		КонецЕсли;
		
		СтрокаТабличнойЧасти = Декларация.Добавить();  ;
		СтрокаТабличнойЧасти.Строка		= СТЗ.Строка;
		СтрокаТабличнойЧасти.Счет       = СТЗ.Счет;		
		СтрокаТабличнойЧасти.Значение	= СТЗ.Сумма;
		
		Макет = МакетСодержащийЯчейкуКода(СтрокаЧислом);
		
		СтрокаТабличнойЧасти.Наименование = ПолучитьТекстИзМакетаНД(Макет, СтрокаЧислом);
		Если СтрокаТабличнойЧасти.Значение < 0 И СТЗ.ПоложительноеЗначение Тогда 
			УбытокОтКР						= СтрокаТабличнойЧасти.Значение;			
			СтрокаТабличнойЧасти.Значение	= 0;
		КонецЕсли;
		
		Если УбытокОтКР <> 0 И СТЗ.Строка = "262" Тогда
			СтрокаТабличнойЧасти.Значение = ?(СтрокаТабличнойЧасти.Значение < 0, СтрокаТабличнойЧасти.Значение * -1 , СтрокаТабличнойЧасти.Значение); 
		КонецЕсли;			
		
		СТЗ.Сумма = СтрокаТабличнойЧасти.Значение;
		
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Рассчитана строка %1'"), СТЗ.Строка);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЦикла;
	
	// Расчет формульных строк первичный
	Пока ВыборкаФормул.Следующий() Цикл
		СтрокаЧислом = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ВыборкаФормул.Строка);
		
		Если СтрокаЧислом = Неопределено Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'В регистре сведений ""Коды строк налоговой декларации"", за %1 год, не верно заполнена строка %2!'"), 
								Формат(Год(Дата), "ЧГ=0"), ВыборкаФормул.Строка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Продолжить;
		КонецЕсли;
		
		Если ВыборкаФормул.УровеньИтога = 1 Тогда  
			СтрокаТабличнойЧасти = Декларация.Добавить();
			СтрокаТабличнойЧасти.Строка		= ВыборкаФормул.Строка;
			СтрокаТабличнойЧасти.Счет       = ВыборкаФормул.Счет;					
			СтрокаТабличнойЧасти.Значение	= РезультатПоФормуле(ТЗСчетов, ВыборкаФормул.Формула);
			Макет = МакетСодержащийЯчейкуКода(СтрокаЧислом); 
			СтрокаТабличнойЧасти.Наименование = ПолучитьТекстИзМакетаНД(Макет, СтрокаЧислом);
			Если СтрокаТабличнойЧасти.Значение < 0 И ВыборкаФормул.ПоложительноеЗначение Тогда 
				СтрокаТабличнойЧасти.Значение	= 0;
			КонецЕсли;
			//ВыборкаФормул.Сумма = СтрокаТабличнойЧасти.Значение;
			
			//ДополнительнаяВыборкаФормул = ТЗСчетов.Найти(ВыборкаФормул.Строка, "Строка");
			//Если ДополнительнаяВыборкаФормул = Неопределено  Тогда
			//	ДополнительнаяВыборкаФормул = ТЗСчетов.Добавить();	
			//КонецЕсли;
			//ДополнительнаяВыборкаФормул.Строка = ВыборкаФормул.Строка;
			//ДополнительнаяВыборкаФормул.Сумма  = СтрокаТабличнойЧасти.Значение;
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Рассчитана формульная строка %1'"), ВыборкаФормул.Строка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			
			// Сумма 259	
		ИначеЕсли ВыборкаФормул.УровеньИтога = 8 И ВыборкаФормул.Строка = "259" Тогда 
			СтрокаТабличнойЧасти = Декларация.Добавить();
			СтрокаТабличнойЧасти.Строка		= ВыборкаФормул.Строка;
			СтрокаТабличнойЧасти.Счет       = ВыборкаФормул.Счет;					
			СтрокаТабличнойЧасти.Значение	= 0;
			СтрокаТабличнойЧасти.Наименование = ПолучитьТекстИзМакетаНД(Макет, СтрокаЧислом);	
			//ВыборкаФормул.Сумма = СтрокаТабличнойЧасти.Значение;
			
			// Сумма 260
		ИначеЕсли ВыборкаФормул.УровеньИтога = 8 И ВыборкаФормул.Строка = "260" Тогда 
			СтрокаТабличнойЧасти = Декларация.Добавить();
			СтрокаТабличнойЧасти.Строка		= ВыборкаФормул.Строка;
			СтрокаТабличнойЧасти.Счет       = ВыборкаФормул.Счет;					
			СтрокаТабличнойЧасти.Значение	= 0;
	        СтрокаТабличнойЧасти.Наименование = ПолучитьТекстИзМакетаНД(Макет, СтрокаЧислом);	
			//ВыборкаФормул.Сумма = СтрокаТабличнойЧасти.Значение;
			
			// Сумма 266	
		ИначеЕсли ВыборкаФормул.УровеньИтога = 8 И ВыборкаФормул.Строка = "266" Тогда 
			СтрокаТабличнойЧасти = Декларация.Добавить();
			СтрокаТабличнойЧасти.Строка		= ВыборкаФормул.Строка;
			СтрокаТабличнойЧасти.Счет       = ВыборкаФормул.Счет;					
			СтрокаТабличнойЧасти.Значение	= 0;
			СтрокаТабличнойЧасти.Наименование = ПолучитьТекстИзМакетаНД(Макет, СтрокаЧислом);	
			//ВыборкаФормул.Сумма = СтрокаТабличнойЧасти.Значение;
			
			// Сумма 267	
		ИначеЕсли ВыборкаФормул.УровеньИтога = 8 И ВыборкаФормул.Строка = "267" Тогда 
			СтрокаТабличнойЧасти = Декларация.Добавить();
			СтрокаТабличнойЧасти.Строка		= ВыборкаФормул.Строка;
			СтрокаТабличнойЧасти.Счет       = ВыборкаФормул.Счет;					
			СтрокаТабличнойЧасти.Значение	= 0;
			СтрокаТабличнойЧасти.Наименование = ПолучитьТекстИзМакетаНД(Макет, СтрокаЧислом);		
			//ВыборкаФормул.Сумма = СтрокаТабличнойЧасти.Значение;
			
		// Расчет формульных строк второго уровня			
		ИначеЕсли ВыборкаФормул.УровеньИтога = 2 Тогда  
			СтрокаТабличнойЧасти = Декларация.Добавить();
			СтрокаТабличнойЧасти.Строка		= ВыборкаФормул.Строка;
			СтрокаТабличнойЧасти.Счет       = ВыборкаФормул.Счет;					
			СтрокаТабличнойЧасти.Значение	= РезультатПоФормуле(ТЗСчетов, ВыборкаФормул.Формула);
			Макет = МакетСодержащийЯчейкуКода(СтрокаЧислом);
			СтрокаТабличнойЧасти.Наименование = ПолучитьТекстИзМакетаНД(Макет, СтрокаЧислом);
			Если СтрокаТабличнойЧасти.Значение < 0 И ВыборкаФормул.ПоложительноеЗначение Тогда 
				СтрокаТабличнойЧасти.Значение	= 0;
			КонецЕсли;
			//ВыборкаФормул.Сумма = СтрокаТабличнойЧасти.Значение;
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Рассчитана формульная строка %1'"), ВыборкаФормул.Строка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		// Расчет формульных строк третьего уровня
		ИначеЕсли ВыборкаФормул.УровеньИтога = 3 Тогда  
			СтрокаТабличнойЧасти = Декларация.Добавить();
			СтрокаТабличнойЧасти.Строка		= ВыборкаФормул.Строка;
			СтрокаТабличнойЧасти.Счет       = ВыборкаФормул.Счет;					
			СтрокаТабличнойЧасти.Значение	= РезультатПоФормуле(ТЗСчетов, ВыборкаФормул.Формула);		
			Макет = МакетСодержащийЯчейкуКода(СтрокаЧислом);
			СтрокаТабличнойЧасти.Наименование = ПолучитьТекстИзМакетаНД(Макет, СтрокаЧислом);			
			Если СтрокаТабличнойЧасти.Значение < 0 И ВыборкаФормул.ПоложительноеЗначение Тогда 
				СтрокаТабличнойЧасти.Значение = 0;
			КонецЕсли;
			//ВыборкаФормул.Сумма = СтрокаТабличнойЧасти.Значение;
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Рассчитана формульная строка %1'"), ВыборкаФормул.Строка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЦикла;
	
	Декларация.Сортировать("Строка");
	
	ТекстСообщения = НСтр("ru = 'Заполнение декларации завершено!'");
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

// Формирование таблицы строк и табоицы итоговых строк
//
Процедура ПолучитьТаблицыКодовСтрокНалоговойДекларации(ТЗсчетов, ВыборкаФормул)
	
	// Выборка сальдо для счетов по РС Коды строк налогой декларации
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КодыСтрокНалоговойДекларации.Строка КАК Строка,
	|	КодыСтрокНалоговойДекларации.Счет КАК Счет,
	|	КодыСтрокНалоговойДекларации.ПоложительноеЗначение КАК ПоложительноеЗначение,
	|	ВЫБОР
	|		КОГДА КодыСтрокНалоговойДекларации.Знак = ЗНАЧЕНИЕ(Перечисление.ПлюсМинус.Минус)
	|			ТОГДА -ЕСТЬNULL(НалоговыйОбороты.СуммаОборот, 0)
	|		ИНАЧЕ ЕСТЬNULL(НалоговыйОбороты.СуммаОборот, 0)
	|	КОНЕЦ КАК Сумма
	|ИЗ
	|	Справочник.КодыСтрокНалоговойДекларации.ТаблицаСтрок КАК КодыСтрокНалоговойДекларации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Обороты(&НачалоПериода, &КонецПериода, , , , Организация = &Организация, , ) КАК НалоговыйОбороты
	|		ПО КодыСтрокНалоговойДекларации.Счет = НалоговыйОбороты.Счет
	|ГДЕ
	|   КодыСтрокНалоговойДекларации.Счет <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка)
	|   И КодыСтрокНалоговойДекларации.Ссылка = &Ссылка
	|УПОРЯДОЧИТЬ ПО
	|	Строка"; 
	
	Запрос.УстановитьПараметр("НачалоПериода",	НачалоГода(Дата));
	Запрос.УстановитьПараметр("КонецПериода",	КонецГода(Дата));
	Запрос.УстановитьПараметр("Ссылка",			КодыСтрокНД);
	Запрос.УстановитьПараметр("Организация",	Организация);
	
	ТЗСчетов = Запрос.Выполнить().Выгрузить();
	
	
	// Выборка формул по РС Коды строк налогой декларации
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КодыСтрокНалоговойДекларации.Строка КАК Строка,
		|	КодыСтрокНалоговойДекларации.Счет КАК Счет,
		|	КодыСтрокНалоговойДекларации.Формула КАК Формула,
		|	КодыСтрокНалоговойДекларации.УровеньИтога КАК УровеньИтога,
		|	КодыСтрокНалоговойДекларации.ПоложительноеЗначение КАК ПоложительноеЗначение,
		|	0 КАК Сумма
		|ИЗ
		|	Справочник.КодыСтрокНалоговойДекларации.ТаблицаСтрок КАК КодыСтрокНалоговойДекларации
		|ГДЕ
		|	КодыСтрокНалоговойДекларации.Формула <> """"
		|	И КодыСтрокНалоговойДекларации.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	Строка";	
	Запрос.УстановитьПараметр("Ссылка",			КодыСтрокНД);
	
	ВыборкаФормул = Запрос.Выполнить().Выбрать();	
КонецПроцедуры

// Функция - функция определения макета.
//
// Параметры:
//  Стр	 - Строка - код строки налоговой декларации 
// 
// Возвращаемое значение:
//   Макет - макет документа. 
//
Функция МакетСодержащийЯчейкуКода(Число)
	
	Если Число >= 150 И Число <= 176 Тогда
		Макет = Документы.ОтчетПоНалогуНаПрибыль.ПолучитьМакет("ПФ_MXL_ЕНД_Приложение1");
	ИначеЕсли Число >= 250 И Число <= 263 Тогда
		Макет = Документы.ОтчетПоНалогуНаПрибыль.ПолучитьМакет("ПФ_MXL_ЕНД_Приложение2");	
	ИначеЕсли Число >= 450 И Число <= 460 Тогда
		Макет = Документы.ОтчетПоНалогуНаПрибыль.ПолучитьМакет("ПФ_MXL_ЕНД_Приложение4");
	Иначе
		Макет = "";
	КонецЕсли;
	
	Возврат Макет;	
КонецФункции // ()

// Процедура - получает текст для наименования из макета.
//
// Параметры:
//  Макет		 - Макет - макет документа;
//  Строка		 - Строка - код строки налоговой декларации;
//  Наименование - Строка - реквизит строки табличной части "Наименование".
//
Функция ПолучитьТекстИзМакетаНД(Макет, Число)
	
	Если Число >= 141 И Число <= 147 Тогда
		Возврат "";
	Иначе
		Наименование = "";
		Попытка
			Наименование = СокрЛП(Макет.Область("С" + Число + "Н").Текст);
		Исключение	
		КонецПопытки;
		
		Возврат Наименование;
	КонецЕсли;
КонецФункции

// Функция - рассчет суммы по формуле.
//
// Параметры:
//  ТЗ		 - ТаблицаЗначений - ТЗ формул (см. процедуру "ПолучитьТаблицыКодовСтрокНалоговойДекларации");  
//  Формула	 - Строка - строка формулы; 
// 
// Возвращаемое значение:
//   Число - сумма, полученная по формуле. 
//
Функция РезультатПоФормуле(Знач ТЗ, Формула)
	
	ТЗ.Свернуть("Строка,ПоложительноеЗначение", "Сумма");
	
	Если Лев(Формула,1) <> "+" И Лев(Формула,1) <> "-" Тогда 
		ТекФормула = "+" + Формула;
	КонецЕсли;		
	
	Сумма = 0;
	
	Пока СтрДлина(ТекФормула) > 0 Цикл 
		ЗнакТС	 	= Лев(ТекФормула,1);
		КодТС		= Сред(ТекФормула,2,3);
		ТекФормула 	= Сред(ТекФормула,5);
		
		СТЗ = ТЗ.Найти(КодТС, "Строка");
		Если СТЗ <> Неопределено Тогда 
			Если ЗнакТС = "+" Тогда 
				Сумма = Сумма + СТЗ.Сумма;
			ИначеЕсли ЗнакТС = "-" Тогда 
				Сумма = Сумма - СТЗ.Сумма;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Сумма;
	
КонецФункции

#КонецОбласти

#КонецЕсли