﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Сортировка = Элементы.Сортировка.СписокВыбора.Получить(0).Значение;
	Отбор = Элементы.Отбор.СписокВыбора.Получить(0).Значение;
	ТекущаяСтраница = 1;
	ИдентификаторПользователя = Пользователи.ТекущийПользователь().ИдентификаторПользователяСервиса;
	
	ЗаполнитьСписокОбращений();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОтправкаСообщенияВСлужбуПоддержки" Или ИмяСобытия = "ПросмотреноВзаимодействиеПоОбращению"  Тогда 
		ПодключитьОбработчикОжидания("ЗаполнитьСписокОбращенийКлиент", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СортировкаПриИзменении(Элемент)
	
	ТекущаяСтраница = 1;
	ЗаполнитьСписокОбращений();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПриИзменении(Элемент)
	
	ТекущаяСтраница = 1;
	ЗаполнитьСписокОбращений();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереходВлевоНажатие(Элемент)
	
	ТекущаяСтраница = ТекущаяСтраница - 1;
	ЗаполнитьСписокОбращений();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереходВправоНажатие(Элемент)
	
	ТекущаяСтраница = ТекущаяСтраница + 1;
	ЗаполнитьСписокОбращений();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбращенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ОбращенияНадписьЕстьОтвет" Тогда 
		ИнформационныйЦентрКлиент.ОткрытьНепросмотренныеВзаимодействия(Элемент.ТекущиеДанные.Идентификатор, Элемент.ТекущиеДанные.СписокНеПросмотренныхВзаимодействий);
	Иначе
		ИнформационныйЦентрКлиент.ОткрытьОбращениеВСлужбуПоддержки(Элемент.ТекущиеДанные.Идентификатор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбратитьсяВСлужбуПоддержки(Команда)
	
	ИнформационныйЦентрКлиент.ОткрытьФормуОтправкиСообщенияВСлужбуПоддержки(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьСписокОбращенийКлиент()
	ЗаполнитьСписокОбращений();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокОбращений()
	
	Попытка
		ПредставлениеСпискаОбращений = ПолучитьПредставлениеСпискаОбращений();
		СформироватьСтраницу(ПредставлениеСпискаОбращений);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИнформационныйЦентрСервер.ПолучитьИмяСобытияДляЖурналаРегистрации(), 
		                         УровеньЖурналаРегистрации.Ошибка,
		                         ,
		                         ,
		                         ТекстОшибки);
		ТекстВывода = ИнформационныйЦентрСервер.ТекстВыводаИнформацииОбОшибкеВСлужбеПоддержки();
		ВызватьИсключение ТекстВывода;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПредставлениеСпискаОбращений()
	
	WSПрокси = ИнформационныйЦентрСервер.ПолучитьПроксиСлужбыПоддержки();
	
	Результат = WSПрокси.getIncidents(Строка(ИдентификаторПользователя), ТекущаяСтраница, Отбор, Сортировка);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура СформироватьСтраницу(ПредставлениеСпискаОбращений)
	
	ЗаполнитьОбращения(ПредставлениеСпискаОбращений);
	
	ЗаполнитьПодвал(ПредставлениеСпискаОбращений);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОбращения(ПредставлениеСпискаОбращений)
	
	Обращения.Очистить();
	Для Каждого ОбращениеОбъект Из ПредставлениеСпискаОбращений.Incidents Цикл 
		
		НовоеОбращение = Обращения.Добавить();
		НовоеОбращение.Идентификатор = Новый УникальныйИдентификатор(ОбращениеОбъект.Id);
		НовоеОбращение.Состояние = ОбращениеОбъект.Status;
		НовоеОбращение.Наименование = ?(ПустаяСтрока(ОбращениеОбъект.Name), НСтр("ru = '<Без темы>'"), ОбращениеОбъект.Name);
		НовоеОбращение.Картинка = ИнформационныйЦентрСервер.КартинкаПоСостояниюОбращения(ОбращениеОбъект.Status);
		НовоеОбращение.Дата = ОбращениеОбъект.Date;
		НовоеОбращение.Номер = ОбращениеОбъект.Number;
		НовоеОбращение.КоличествоНепросмотренныхВзаимодействий = ОбращениеОбъект.UnreviewedInteractions.Количество();
		Если НовоеОбращение.КоличествоНепросмотренныхВзаимодействий <> 0 Тогда 
			ПояснениеКЕстьОтвет = ?(НовоеОбращение.КоличествоНепросмотренныхВзаимодействий = 1, "", " (" + Строка(НовоеОбращение.КоличествоНепросмотренныхВзаимодействий) + ")");
			ЕстьОтвет = ?(НовоеОбращение.КоличествоНепросмотренныхВзаимодействий = 1, НСтр("ru = 'Непрочитанное'"), НСтр("ru = 'Непрочитанные'"));
			НовоеОбращение.НадписьЕстьОтвет = ЕстьОтвет + ПояснениеКЕстьОтвет;
			Для Каждого НепросмотренноеВзаимодействие Из ОбращениеОбъект.UnreviewedInteractions Цикл 
				ЗначениеСписка = Новый Структура;
				ЗначениеСписка.Вставить("Тема", НепросмотренноеВзаимодействие.Name);
				ЗначениеСписка.Вставить("Дата", НепросмотренноеВзаимодействие.Date);
				ЗначениеСписка.Вставить("Описание", НепросмотренноеВзаимодействие.Description);
				ЗначениеСписка.Вставить("Идентификатор", Новый УникальныйИдентификатор(НепросмотренноеВзаимодействие.Id));
				ЗначениеСписка.Вставить("Тип", НепросмотренноеВзаимодействие.Type);
				ЗначениеСписка.Вставить("Входящее", НепросмотренноеВзаимодействие.Incoming);
				НовыйЭлементСписка = НовоеОбращение.СписокНеПросмотренныхВзаимодействий.Добавить(ЗначениеСписка);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодвал(ПредставлениеСпискаОбращений)
	
	ЕстьСтраницыДо = (ТекущаяСтраница > 1);
	ЕстьСтраницыПосле = ПредставлениеСпискаОбращений.IsStill;
	
	Элементы.ПереходВлево.Гиперссылка = ЕстьСтраницыДо;
	Элементы.ПереходВлево.Картинка = ?(ЕстьСтраницыДо, БиблиотекаКартинок.ПереходВлевоАктивный, БиблиотекаКартинок.ПереходВлевоНеАктивный);
	Элементы.ПереходВправо.Картинка = ?(ЕстьСтраницыПосле, БиблиотекаКартинок.ПереходВправоАктивный, БиблиотекаКартинок.ПереходВправоНеАктивный);
	Элементы.ПереходВправо.Гиперссылка = ЕстьСтраницыПосле;
	Элементы.ТекущаяСтраница.Заголовок = ТекущаяСтраница;
	
КонецПроцедуры

#КонецОбласти






