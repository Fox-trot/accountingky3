﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Информационный центр".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Открывает форму отображения отдельной новости.
//
// Параметры:
//	Идентификатор - УникальныйИдентификатор - идентификатор новости.
//
Процедура ПоказатьНовость(Идентификатор) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОткрытьНовость");
	ПараметрыФормы.Вставить("Идентификатор", Идентификатор);
	ОткрытьФорму("Обработка.ИнформационныйЦентр.Форма.ОтображениеСообщений", ПараметрыФормы);
	
КонецПроцедуры

// Открывает форму отображения всех новостей.
//
//
Процедура ПоказатьВсеСообщения() Экспорт
	
	ПараметрыФормы = Новый Структура("ОткрытьВсеСообщения");
	ОткрытьФорму("Обработка.ИнформационныйЦентр.Форма.ОтображениеСообщений", ПараметрыФормы);
	
КонецПроцедуры

// Процедура-обработчик при нажатии на информационную ссылку.
//
// Параметры:
//	Форма - УправляемаяФорма - контекст управляемой формы.
//	Элемент - ЭлементФормы - группа формы.
//
Процедура НажатиеНаИнформационнуюСсылку(Форма, Элемент) Экспорт
	
	Гиперссылка = Форма.ИнформационныеСсылки.НайтиПоЗначению(Элемент.Имя);
	
	Если Гиперссылка <> Неопределено Тогда
		
		ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(Гиперссылка.Представление);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура-обработчик при нажатии на "Все" информационные ссылки.
//
// Параметры:
//	ПутьКФорме - Строка - полный путь к форме.
//
Процедура Подключаемый_НажатиеНаСсылкуВсеИнформационныеСсылки(ПутьКФорме) Экспорт
	
	ПараметрыФормы = Новый Структура("ПутьКФорме", ПутьКФорме);
	ОткрытьФорму("Обработка.ИнформационныйЦентр.Форма.ИнформационныеСсылкиВКонтексте", ПараметрыФормы);
	
КонецПроцедуры

// Открывает форму с содержанием пожелания.
//
// ИдентификаторПожелания - Строка - уникальный идентификатор пожелания.
//
Процедура ПоказатьИдею(Знач ИдентификаторИдеи) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИдентификаторИдеи", ИдентификаторИдеи);
	ПараметрыФормы.Вставить("ТекущаяСтраницаКомментариев", 1);
	ОткрытьФорму("Обработка.ИнформационныйЦентр.Форма.Идея", ПараметрыФормы, , Новый УникальныйИдентификатор);
	
КонецПроцедуры

// Открывает форму с Центром идей.
//
Процедура ОткрытьЦентрИдей() Экспорт 
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущийФильтрИдей", "voiting");
	ПараметрыФормы.Вставить("ТекущаяСортировка", "CreateDate");
	ПараметрыФормы.Вставить("ТекущаяСтраница", 1);
	ОткрытьФорму("Обработка.ИнформационныйЦентр.Форма.ЦентрИдей", ПараметрыФормы, , Новый УникальныйИдентификатор);
	
КонецПроцедуры

// Открывает форму со всеми обращениями в службу поддержки.
//
Процедура ОткрытьОбращенияВСлужбуПоддержки() Экспорт 
	
	ОткрытьФорму("Обработка.ИнформационныйЦентр.Форма.ОбращенияВСлужбуПоддержки", , , Новый УникальныйИдентификатор);
	
КонецПроцедуры

// Открывает форму по отправке сообщения получателю.
//
// Параметры:
//	СоздаватьОбращения - Булево - создавать или нет обращения.
//
Процедура ОткрытьФормуОтправкиСообщенияВСлужбуПоддержки(СоздаватьОбращение, ИдентификаторОбращения = Неопределено) Экспорт
	
	ПараметрыСообщения = Новый Структура;
	ПараметрыСообщения.Вставить("СоздаватьОбращение", СоздаватьОбращение);
	Если ИдентификаторОбращения <> Неопределено Тогда 
		ПараметрыСообщения.Вставить("ИдентификаторОбращения", ИдентификаторОбращения);
	КонецЕсли;
	ОткрытьФорму("Обработка.ИнформационныйЦентр.Форма.ОтправкаСообщенияВСлужбуПоддержки", ПараметрыСообщения);
	
КонецПроцедуры

// Открывает форму с обращением в службу поддержки
//
// Параметры:
//	ИдентификаторОбращения - УникальныйИдентификатор - идентификатор обращения.
//
Процедура ОткрытьОбращениеВСлужбуПоддержки(ИдентификаторОбращения) Экспорт
	
	ПараметрыОбращения = Новый Структура;
	ПараметрыОбращения.Вставить("ИдентификаторОбращения", ИдентификаторОбращения);
	ОткрытьФорму("Обработка.ИнформационныйЦентр.Форма.ВзаимодействияПоОбращению", ПараметрыОбращения, , Новый УникальныйИдентификатор);
	
КонецПроцедуры

// Открывает взаимодействие по обращению.
//
// Параметры:
//	ИдентификаторОбращения - УникальныйИдентификатор - идентификатор обращения.
//	ИдентификаторВзаимодействия - УникальныйИдентификатор - идентификатор взаимодействия.
//	ТипВзаимодействия - Строка - тип взаимодействия.
//	Входящее - Булево - признак: входящее сообщение или нет.
//	Просмотрено - Булево - признак: просмотрено сообщение, или нет.
//
Процедура ОткрытьВзаимодействиеВСлужбуПоддержки(ИдентификаторОбращения, ИдентификаторВзаимодействия, ТипВзаимодействия, Входящее, Просмотрено = Истина) Экспорт 
	
	ПараметрыВзаимодействия = Новый Структура;
	ПараметрыВзаимодействия.Вставить("ИдентификаторОбращения", ИдентификаторОбращения);
	ПараметрыВзаимодействия.Вставить("ИдентификаторВзаимодействия", ИдентификаторВзаимодействия);
	ПараметрыВзаимодействия.Вставить("ТипВзаимодействия", ТипВзаимодействия);
	ПараметрыВзаимодействия.Вставить("Входящее", Входящее);
	ПараметрыВзаимодействия.Вставить("Просмотрено", Просмотрено);
	ОткрытьФорму("Обработка.ИнформационныйЦентр.Форма.ВзаимодействиеПоОбращению", ПараметрыВзаимодействия, , Новый УникальныйИдентификатор);
	
КонецПроцедуры

// Открывает непросмотренные взаимодействия.
//
// Параметры:
//	ИдентификаторОбращения - УникальныйИдентификатор - идентификатор обращения.
//	СписокНеПросмотренныхВзаимодействий - СписокЗначений - список непросмотренных взаимодействий.
//
Процедура ОткрытьНепросмотренныеВзаимодействия(ИдентификаторОбращения, СписокНеПросмотренныхВзаимодействий) Экспорт 
	
	Если СписокНеПросмотренныхВзаимодействий.Количество() = 1 Тогда 
		ПервоеВзаимодействие = СписокНеПросмотренныхВзаимодействий.Получить(0).Значение;
		ОткрытьВзаимодействиеВСлужбуПоддержки(ИдентификаторОбращения, ПервоеВзаимодействие.Идентификатор, ПервоеВзаимодействие.Тип, ПервоеВзаимодействие.Входящее, Ложь);
	Иначе
		Параметры = Новый Структура;
		Параметры.Вставить("СписокНеПросмотренныхВзаимодействий", СписокНеПросмотренныхВзаимодействий);
		Параметры.Вставить("ИдентификаторОбращения", ИдентификаторОбращения);
		ОткрытьФорму("Обработка.ИнформационныйЦентр.Форма.НеПросмотренныеВзаимодействия", Параметры, , Новый УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
