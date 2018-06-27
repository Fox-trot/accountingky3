﻿////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеКлиентСервер: общий механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область РаботаСМаршрутамиПодписания

////////////////////////////////////////////////////////////////////////////////
// Отрисовка дерева

// Определяет параметры подчиненных строк дерева подписания, необходимые для работы механизмов отрисовки и
// редактирования.
//
// Параметры:
//  СтрокаДерева		 - ДанныеФормыЭлементДерева - строка дерева.
//  ЕстьУсловия			 - Булево - в параметр возвращается Истина, если в подчиненных строках указаны требования к
//    подписанию.
//  ЕстьПодписанты		 - Булево - в параметр возвращается Истина, если в подчиненных строках указаны подписанты.
//  ВыбранныеЗначения	 - Массив - требования или подписанты, выбранные в подчиненных строках.
//
Процедура ОпределитьПараметрыПодчиненныхСтрокДерева(СтрокаДерева, ЕстьУсловия = Ложь, ЕстьПодписанты = Ложь,
		ВыбранныеЗначения = Неопределено) Экспорт
	
	Если СтрокаДерева <> Неопределено Тогда
		ПодчиненныеСтроки = СтрокаДерева.ПолучитьЭлементы();
		Если ВыбранныеЗначения = Неопределено Тогда
			ВыбранныеЗначения = Новый Массив;
		КонецЕсли;
		
		Для Каждого ПодчиненнаяСтрока Из ПодчиненныеСтроки Цикл
			Если ПодчиненнаяСтрока.ЭтоСтрокаУсловия Тогда
				ЕстьУсловия = Истина;
				ВыбранныеЗначения.Добавить(ПодчиненнаяСтрока.Требование);
			Иначе
				ЕстьПодписанты = Истина;
				ВыбранныеЗначения.Добавить(ПодчиненнаяСтрока.Подписант);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Заполняет служебные реквизиты дерева подписания.
//
// Параметры:
//  СтрокаДерева - ДанныеФормыЭлементДерева, СтрокаДереваЗначений - строка дерева.
//  ИмяОсновногоРеквизита- Строка - имя реквизита дерева, который будет выводиться в основной колонке.
//
Процедура ЗаполнитьСлужебныеРеквизитыСтрокиДерева(СтрокаДерева, ИмяОсновногоРеквизита = "Подписант") Экспорт
	
	Если ЗначениеЗаполнено(СтрокаДерева.Требование) ИЛИ СтрокаДерева.ЭтоСтрокаУсловия Тогда
		СтрокаДерева.ЭтоСтрокаУсловия	= Истина;
		СтрокаДерева.ИндексКартинки		= 2;
		СтрокаДерева.ОсновноеЗначение	= ПредставлениеТребованияСтроки(СтрокаДерева);
	Иначе
		СтрокаДерева.ЭтоСтрокаУсловия 	= Ложь;
		
		Если ЗначениеЗаполнено(СтрокаДерева.Сертификат) Тогда
			СтрокаДерева.ИндексКартинки 	= 1;
		Иначе
			СтрокаДерева.ИндексКартинки 	= 0;
		КонецЕсли;
		
		СтрокаДерева.ОсновноеЗначение = СтрокаДерева[ИмяОсновногоРеквизита];
		
		Если СтрокаДерева.Свойство("ОтборСертификатов") Тогда
			СписокПодписантовДляОтбора = Новый СписокЗначений;
			СписокПодписантовДляОтбора.Добавить(ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка"));
			Если ЗначениеЗаполнено(СтрокаДерева.Подписант) Тогда
				СписокПодписантовДляОтбора.Добавить(СтрокаДерева.Подписант);
			КонецЕсли;
			СтрокаДерева.ОтборСертификатов = СписокПодписантовДляОтбора;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Определяет соответствие текстовых представлений требований их ссылочным значениям.
//
// Параметры:
//  СтрокаДерева - ДанныеФормыЭлементДерева - строка дерева.
// 
// Возвращаемое значение:
//  Соответствие - ключом является требование, значением - его текстовое представление.
//
Функция СоответствиеПредставленийТребованиям(СтрокаДерева) Экспорт

	ЕстьТребования = Ложь;
	ЕстьПодписанты = Ложь;
	ОпределитьПараметрыПодчиненныхСтрокДерева(СтрокаДерева, ЕстьТребования, ЕстьПодписанты);
	
	СоответствиеПредставленийТребованиям = Новый Соответствие;
	СоответствиеПредставленийТребованиям.Вставить(ПредопределенноеЗначение("Перечисление.ТребованияКПодписаниюЭД.ИЛИ"), 
		НСтр("ru = 'Поставить любую из подписей'"));
	СоответствиеПредставленийТребованиям.Вставить(ПредопределенноеЗначение("Перечисление.ТребованияКПодписаниюЭД.И"), 
		НСтр("ru = 'Поставить все подписи'"));
	СоответствиеПредставленийТребованиям.Вставить(ПредопределенноеЗначение("Перечисление.ТребованияКПодписаниюЭД.ПоПорядку"), 
		НСтр("ru = 'Поставить все подписи по порядку'"));
	
	Если ЕстьТребования И Не ЕстьПодписанты Тогда
		СоответствиеПредставленийТребованиям.Вставить(ПредопределенноеЗначение("Перечисление.ТребованияКПодписаниюЭД.ИЛИ"), 
			НСтр("ru = 'Выполнить любое из требований'"));
		СоответствиеПредставленийТребованиям.Вставить(ПредопределенноеЗначение("Перечисление.ТребованияКПодписаниюЭД.И"), 
			НСтр("ru = 'Выполнить все требования'"));
		СоответствиеПредставленийТребованиям.Вставить(ПредопределенноеЗначение("Перечисление.ТребованияКПодписаниюЭД.ПоПорядку"), 
			НСтр("ru = 'Выполнить все требования по порядку'"));
	ИначеЕсли ЕстьПодписанты И Не ЕстьТребования Тогда
		СоответствиеПредставленийТребованиям.Вставить(ПредопределенноеЗначение("Перечисление.ТребованияКПодписаниюЭД.ИЛИ"), 
			НСтр("ru = 'Поставить любую из подписей'"));
		СоответствиеПредставленийТребованиям.Вставить(ПредопределенноеЗначение("Перечисление.ТребованияКПодписаниюЭД.И"), 
			НСтр("ru = 'Поставить все подписи'"));
		СоответствиеПредставленийТребованиям.Вставить(ПредопределенноеЗначение("Перечисление.ТребованияКПодписаниюЭД.ПоПорядку"), 
			НСтр("ru = 'Поставить все подписи по порядку'"));
	КонецЕсли;
		
	Возврат СоответствиеПредставленийТребованиям;	

КонецФункции 

#КонецОбласти

#Область ОбработкаОшибок

// Формирует служебную структуру, которая может быть использована для указания параметров обработки ошибок для
// реквизитов дерева данных электронного документа.
//
// Параметры:
//  КлючДанных			 - ЛюбаяСсылка - ключ данных для обработки через сообщение пользователю (см. СообщениеПользователю).
//  ПутьКДанным			 - Строка - путь к данным для обработки через сообщение пользователю (см. СообщениеПользователю).
//  НавигационнаяСсылка	 - Строка - навигационная ссылка, по которой нужно перейти при клике на ошибку.
//  ИмяФормы			 - Строка - имя формы, которую нужно открыть при клике на ошибку.
//  ПараметрыФормы		 - Структура - параметры, передаваемые в форму, открываемую при клике на ошибку.
//  ТекстОшибки			 - Строка - используется для переопределения стандартного текста ошибки.
// 
// Возвращаемое значение:
//  Структура - содержит следующие ключи:
//    * КлючСообщения - заполняется из параметра "КлючДанных".
//    * ПутьКДаннымСообщения - заполняется из параметра "ПутьКДанным".
//    * НавигационнаяСсылка - заполняется из параметра "НавигационнаяСсылка".
//    * ИмяФормы - заполняется из параметра "ИмяФормы".
//    * ПараметрыФормы - заполняется из параметра "ПараметрыФормы".
//    * ТекстОшибки - заполняется из параметра "ТекстОшибки".
//
Функция НовыеПараметрыОшибки(КлючДанных = Неопределено, ПутьКДанным = "", НавигационнаяСсылка = "", ИмяФормы = "",
	ПараметрыФормы = Неопределено, ТекстОшибки = "") Экспорт

	ДанныеОшибки = Новый Структура;
	ДанныеОшибки.Вставить("КлючСообщения", КлючДанных);
	ДанныеОшибки.Вставить("ПутьКДаннымСообщения", ПутьКДанным);
	ДанныеОшибки.Вставить("НавигационнаяСсылка", НавигационнаяСсылка);
	ДанныеОшибки.Вставить("ИмяФормы", ИмяФормы);
	ДанныеОшибки.Вставить("ПараметрыФормы", ПараметрыФормы);
	ДанныеОшибки.Вставить("ТекстОшибки", ТекстОшибки);
	
	Возврат ДанныеОшибки;

КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПредставлениеТребованияСтроки(СтрокаДерева)
	
	Результат = "";
	Если ЗначениеЗаполнено(СтрокаДерева.Требование) Тогда
		Результат = СоответствиеПредставленийТребованиям(СтрокаДерева)[СтрокаДерева.Требование];
	КонецЕсли;
	Возврат Результат;

КонецФункции

#КонецОбласти