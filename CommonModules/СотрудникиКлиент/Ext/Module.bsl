﻿////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы ФизическогоЛица

Процедура ФизическиеЛицаОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	СотрудникиКлиентВнутренний.ФизическиеЛицаОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

Процедура ФизическиеЛицаПередЗаписью(Форма, Отказ, ПараметрыЗаписи, ОповещениеЗавершения = Неопределено, ЗакрытьПослеЗаписи = Истина) Экспорт
	СотрудникиКлиентВнутренний.ФизическиеЛицаПередЗаписью(Форма, Отказ, ПараметрыЗаписи, ОповещениеЗавершения, ЗакрытьПослеЗаписи);
КонецПроцедуры

Процедура ФизическиеЛицаПослеЗаписи(Форма, ПараметрыЗаписи) Экспорт
    ЛичныеДанныеФизическогоЛицаПослеЗаписи(Форма, Форма.Физлицо);

    ФизЛицо = Форма.ФизЛицо;
    ОповеститьОбИзмененииДанныхФизическогоЛица(Форма, ФизЛицо);

    Форма.ВыполненаКомандаСменыФИО = Ложь;
    Форма.Элементы.ФИО.ТолькоПросмотр = Ложь;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Служебные процедуры

Процедура ОповеститьОбИзмененииДанныхФизическогоЛица(Форма, ФизическоеЛицо)
	
	ДанныеФизическогоЛица = Новый Структура;
	ДанныеФизическогоЛица.Вставить("ФизическоеЛицо", ФизическоеЛицо.Ссылка);
	ДанныеФизическогоЛица.Вставить("Фамилия", "");
	ДанныеФизическогоЛица.Вставить("Имя", "");
	ДанныеФизическогоЛица.Вставить("Отчество", "");
	ДанныеФизическогоЛица.Вставить("Пол", ФизическоеЛицо.Пол);
	ДанныеФизическогоЛица.Вставить("ДатаРождения", ФизическоеЛицо.ДатаРождения);
	ДанныеФизическогоЛица.Вставить("Гражданство", "");
	ДанныеФизическогоЛица.Вставить("ИНН", ФизическоеЛицо.ИНН);
	ДанныеФизическогоЛица.Вставить("ВидДокумента");
	ДанныеФизическогоЛица.Вставить("Серия", "");
	ДанныеФизическогоЛица.Вставить("Номер", "");
	ДанныеФизическогоЛица.Вставить("КемВыдан", "");
	ДанныеФизическогоЛица.Вставить("ДатаВыдачи", '00010101');
	ДанныеФизическогоЛица.Вставить("КодПодразделения", "");
	ДанныеФизическогоЛица.Вставить("ПредставлениеДокумента", "");
										
	Если Форма.ДоступенПросмотрДанныхФизическихЛиц Тогда
		ДанныеФизическогоЛица.Фамилия 		= Форма.ФИОФизическихЛиц.Фамилия;
		ДанныеФизическогоЛица.Имя 			= Форма.ФИОФизическихЛиц.Имя;
		ДанныеФизическогоЛица.Отчество 		= Форма.ФИОФизическихЛиц.Отчество;
		ДанныеФизическогоЛица.Гражданство 	= Форма.ГражданствоФизическихЛиц.Страна;

		ДанныеФизическогоЛица.ВидДокумента 	= Форма.ДокументыФизическихЛиц.ВидДокумента;
		ДанныеФизическогоЛица.Серия 		= Форма.ДокументыФизическихЛиц.Серия;
		ДанныеФизическогоЛица.Номер 		= Форма.ДокументыФизическихЛиц.Номер;
		ДанныеФизическогоЛица.КемВыдан 		= Форма.ДокументыФизическихЛиц.КемВыдан;
		ДанныеФизическогоЛица.ДатаВыдачи 	= Форма.ДокументыФизическихЛиц.ДатаВыдачи;
		ДанныеФизическогоЛица.КодПодразделения 	= Форма.ДокументыФизическихЛиц.КодПодразделения;
		ДанныеФизическогоЛица.ПредставлениеДокумента 	= Форма.ДокументыФизическихЛиц.Представление;
	КонецЕсли;
										
	Оповестить("ИзменениеДанныхФизическогоЛица", ДанныеФизическогоЛица, ФизическоеЛицо.Ссылка);
	
	Оповестить("Запись_ФизическиеЛица", , ФизическоеЛицо.Ссылка);
КонецПроцедуры

Функция ЗаблокироватьФизическоеЛицоПриРедактировании(Форма, СообщатьОНевозможностиБлокировки = Истина) Экспорт
	Если НЕ Форма.ФизическоеЛицоЗаблокировано Тогда
		Если НЕ СотрудникиВызовСервера.ЗаблокироватьФизическоеЛицоПриРедактированииНаСервере(Форма.ФизическоеЛицоСсылка, Форма.ФизическоеЛицоВерсияДанных, Форма.УникальныйИдентификатор) Тогда
			Если СообщатьОНевозможностиБлокировки Тогда
				ПоказатьПредупреждение(, НСтр("ru = 'Не удается внести изменения в личные данные сотрудника. Возможно, личные данные сотрудника редактируются другим пользователем.'"));
			КонецЕсли; 
			// заблокировать не удалось - обновить данные физлица
			Форма.ПрочитатьДанныеСвязанныеСФизлицом();
			Возврат Ложь;
		Иначе
			Форма.ФизическоеЛицоЗаблокировано = Истина;
		КонецЕсли;
	КонецЕсли;
	Возврат Истина;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции обслуживания личных данных физического лица

Процедура ЛичныеДанныеФизическогоЛицаПослеЗаписи(Форма, ФизическоеЛицоСсылка)
	
	Если Форма.ИзмененыЛичныеДанные Тогда
		
		Оповестить("ИзменениеЛичныхДанных", ФизическоеЛицоСсылка, Форма);
		Форма.ИзмененыЛичныеДанные = Ложь;
		
	КонецЕсли;	
	
КонецПроцедуры	

Процедура ЛичныеДанныеФизическогоЛицаОбработкаОповещения(ИмяСобытия, Параметр, Источник, Форма) Экспорт
	
	Если ИмяСобытия = "ИзменениеЛичныхДанных"
		И Параметр = Форма.ФизическоеЛицоСсылка
		И Источник <> Форма Тогда
		
		Форма.Прочитать();
		
	КонецЕсли;
	
КонецПроцедуры	

Процедура ФизическиеЛицаМестоРожденияНачалоВыбора(Форма, Элемент, СтандартнаяОбработка, МестоРождения, ОповещениеЗавершения = Неопределено) Экспорт	
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("Элемент", Элемент);
	ДополнительныеПараметры.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Представление", МестоРождения);
	
	Оповещение = Новый ОписаниеОповещения("ФизическиеЛицаМестоРожденияНачалоВыбораЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ВводМестаРождения", ПараметрыФормы, , , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры

Процедура ФизическиеЛицаМестоРожденияНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт	
	
	Если Результат <> Неопределено Тогда
		
		Форма = ДополнительныеПараметры.Форма;
		Элемент = ДополнительныеПараметры.Элемент;
		ОповещениеЗавершения = ДополнительныеПараметры.ОповещениеЗавершения;
		
		Форма.Физлицо.МестоРождения = Результат;
		Форма[Элемент.Имя] = ОбщегоНазначенияБПКлиентСервер.ПредставлениеМестаРождения(Результат);
		Форма.Модифицированность = Истина;

	КонецЕсли;
	
	Если ОповещениеЗавершения <> Неопределено Тогда
		МестоРожденияИзменено = Результат <> Неопределено;
		ВыполнитьОбработкуОповещения(ОповещениеЗавершения, МестоРожденияИзменено);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры обслуживания данных о ФИО

Процедура ПриИзмененииФИО(Форма, ФизическоеЛицо, МенеджерЗаписиФИО)
	
	СтруктураФИО = ФизическиеЛицаКлиентСервер.ФамилияИмяОтчество(ФизическоеЛицо.ФИО);
	Если СтруктураФИО.Фамилия <> Неопределено Тогда
		МенеджерЗаписиФИО.Фамилия  = СтруктураФИО.Фамилия;
		Если СтруктураФИО.Имя <> Неопределено Тогда
			МенеджерЗаписиФИО.Имя = СтруктураФИО.Имя;
		КонецЕсли;
		Если СтруктураФИО.Отчество <> Неопределено Тогда
			МенеджерЗаписиФИО.Отчество = СтруктураФИО.Отчество;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(МенеджерЗаписиФИО.Период) Тогда
			Если ЗначениеЗаполнено(ФизическоеЛицо.ДатаРождения) Тогда
				МенеджерЗаписиФИО.Период = ФизическоеЛицо.ДатаРождения;
			Иначе
				МенеджерЗаписиФИО.Период = ЗарплатаКадрыКлиентСервер.ДатаОтсчетаПериодическихСведений();
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(МенеджерЗаписиФИО.Отчество) И Не ЗначениеЗаполнено(ФизическоеЛицо.Пол) Тогда
			ФизическоеЛицо.Пол = СотрудникиКлиентСервер.ОпределитьПолПоОтчеству(МенеджерЗаписиФИО.Отчество);
		КонецЕсли;
	КонецЕсли;
	
	СотрудникиКлиентСервер.УстановитьВидимостьПолейФИО(Форма);	
КонецПроцедуры

Процедура УстановитьТолькоПросмотрФИО(Элемент, ИзменениеЗаднимЧислом, ПериодНачалаДействия, ПериодОкончанияДействия) 
	Если ИзменениеЗаднимЧислом Тогда 
		ТекстПредупреждения = СтрШаблон(НСтр("ru = 'Изменение ФИО выполнено ""задним числом"". Введенное данные действуют с %1 по %2.
                                                                                            |Редактирование ФИО непосредственно в форме сейчас недоступно и будет доступно только после записи.'"),
																					  Формат(ПериодНачалаДействия, "ДФ=дд.ММ.гггг"),
																					  Формат(ПериодОкончанияДействия, "ДФ=дд.ММ.гггг"));
		ПоказатьПредупреждение(, ТекстПредупреждения);
		
		Элемент.ТолькоПросмотр = Истина;
		
	КонецЕсли;	
КонецПроцедуры	

Процедура ИзменитьФИОФизическогоЛица(Форма, ОповещениеЗавершения = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура("Форма, ОповещениеЗавершения", Форма, ОповещениеЗавершения);
	
	СтруктураФИО = ФизическиеЛицаКлиентСервер.ФамилияИмяОтчество(Форма.Физлицо.ФИО);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Фамилия", ?(СтруктураФИО.Фамилия = Неопределено, "", СтруктураФИО.Фамилия));
	ПараметрыФормы.Вставить("Имя", ?(СтруктураФИО.Имя = Неопределено, "", СтруктураФИО.Имя));
	ПараметрыФормы.Вставить("Отчество", ?(СтруктураФИО.Отчество = Неопределено, "", СтруктураФИО.Отчество));
	ПараметрыФормы.Вставить("ДатаИзменения", ЗарплатаКадрыКлиентСервер.ДатаСеанса());

	Оповещение = Новый ОписаниеОповещения("ИзменитьФИОФизическогоЛицаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.СменаФИО", ПараметрыФормы, Форма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура ИзменитьФИОФизическогоЛицаЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Форма = ДополнительныеПараметры.Форма;
	ОповещениеЗавершения = ДополнительныеПараметры.ОповещениеЗавершения;
	МенеджерЗаписиФИО = Форма.ФИОФизическихЛиц;
	
	Если Результат <> Неопределено Тогда
		// нажали ОК
		Если Результат.ДатаИзменения >= МенеджерЗаписиФИО.Период Тогда
			// изменим имя только если это - хронологически последняя запись регистра ФИО
			НовоеНаименование = Результат.Фамилия + " " + Результат.Имя + " " + Результат.Отчество;
		Иначе
			// вернем прежнее имя если это - ввод хронологически не последней записи регистра ФИО
			НовоеНаименование = МенеджерЗаписиФИО.Фамилия + " " + МенеджерЗаписиФИО.Имя + " " + МенеджерЗаписиФИО.Отчество;
		КонецЕсли;
		
		Результат.Вставить("НовоеНаименование", НовоеНаименование);
		Результат.Вставить("ИзменениеЗаднимЧислом", Результат.ДатаИзменения < МенеджерЗаписиФИО.Период);
		Результат.Вставить("ДатаТекущейЗаписи", МенеджерЗаписиФИО.Период);
		
		МенеджерЗаписиФИО.Фамилия = Результат.Фамилия;
		МенеджерЗаписиФИО.Имя = Результат.Имя;
		МенеджерЗаписиФИО.Отчество = Результат.Отчество;
		МенеджерЗаписиФИО.Период = Результат.ДатаИзменения;
		МенеджерЗаписиФИО.Основание = Результат.Основание;
		
		Форма.ВыполненаКомандаСменыФИО = Истина;
		Форма.ФИОФизическихЛицНоваяЗапись = Истина;
		Форма.Модифицированность = Истина;
		
		Если ОповещениеЗавершения <> Неопределено Тогда 
		    ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Результат);
		КонецЕсли;
		
	Иначе
			
		Форма.ФИОФизическихЛицНоваяЗапись = Ложь;
		Если ОповещениеЗавершения <> Неопределено Тогда 
		    ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Результат);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИзменитьФИОСотрудника(Форма, ОповещениеЗавершения = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура("Форма, ОповещениеЗавершения", Форма, ОповещениеЗавершения);
	
	Оповещение = Новый ОписаниеОповещения("ИзменитьФИОСотрудникаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ИзменитьФИОФизическогоЛица(Форма, Оповещение);
	
КонецПроцедуры

Процедура ИзменитьФИОСотрудникаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	ОповещениеЗавершения = ДополнительныеПараметры.ОповещениеЗавершения;
	
	Если Результат <> Неопределено Тогда
		Если Форма.Физлицо.ФИО <> Результат.НовоеНаименование Тогда
			Если Не Результат.ИзменениеЗаднимЧислом И ЗаблокироватьФизическоеЛицоПриРедактировании(Форма) Тогда
				Форма.Физлицо.ФИО = Результат.НовоеНаименование;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Результат);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриИзмененииФИОФизическогоЛица(Форма) Экспорт
	
	ПриИзмененииФИО(Форма, Форма.Физлицо, Форма.ФИОФизическихЛиц);
	
КонецПроцедуры

Процедура ФизическоеЛицоИзменилФИОНажатие(Форма) Экспорт
	
	ДополнительныеПараметры = Новый Структура("Форма", Форма);
	
	Оповещение = Новый ОписаниеОповещения("ФизическоеЛицоИзменилФИОНажатиеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ИзменитьФИОФизическогоЛица(Форма, Оповещение);
	
КонецПроцедуры

Процедура ФизическоеЛицоИзменилФИОНажатиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	
	Если Результат <> Неопределено Тогда
		Если Не Результат.ИзменениеЗаднимЧислом Тогда
			Форма.Физлицо.ФИО = Результат.НовоеНаименование;
		КонецЕсли; 
		УстановитьТолькоПросмотрФИО(Форма.Элементы.ФИО, Результат.ИзменениеЗаднимЧислом, Форма.ФИОФизическихЛиц.Период, Результат.ДатаТекущейЗаписи);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Управление отображением и доступностью документа удостоверяющего личность

Процедура ДокументыФизическихЛицВидДокументаПриИзменении(Форма) Экспорт
	СотрудникиКлиентВнутренний.ДокументыФизическихЛицВидДокументаПриИзменении(Форма);
КонецПроцедуры

Процедура ДокументыФизическихЛицВидДокументаНачалоВыбора(Форма, Элемент, СтандартнаяОбработка) Экспорт
	Если НЕ ЗначениеЗаполнено(Форма.ДокументыФизическихЛиц.ВидДокумента) Тогда
		Форма.ДокументыФизическихЛиц.ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.Паспорт");
	КонецЕсли; 
КонецПроцедуры

Процедура ОткрытьСписокВсехДокументовФизическогоЛица(Форма, ФизическоеЛицоСсылка) Экспорт
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Физлицо", ФизическоеЛицоСсылка);
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("Отбор", СтруктураОтбора);
	ОткрытьФорму("РегистрСведений.ДокументыФизическихЛиц.Форма.ДокументыФизическогоЛица", ПараметрыОткрытияФормы, Форма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Проверка модифицированности гражданства, удостоверения личности

Процедура ЗапроситьРежимИзмененияГражданства(ФормаИсточник, ДатаИзменения, Отказ, ОповещениеЗавершения = Неопределено) Экспорт
	Если ФормаИсточник.ДоступенПросмотрДанныхФизическихЛиц Тогда
		
		ТекстКнопкиДа = НСтр("ru = 'Изменилось гражданство'");
		ТекстВопроса = СтрШаблон(
				НСтр("ru =  'При редактировании изменены сведения о гражданстве. 
							|Если исправлена прежняя запись о гражданстве (она была ошибочной), нажмите ""Исправлена ошибка"".
							|Если у сотрудника изменилось гражданство с %1, нажмите ""%2""'"), 
				Формат(ДатаИзменения, "ДФ='д ММММ гггг ""г""'"),
				ТекстКнопкиДа);
		
		РедактированиеПериодическихСведенийКлиент.ЗапроситьРежимИзмененияРегистра(ФормаИсточник, "ГражданствоФизическихЛиц", ТекстВопроса, ТекстКнопкиДа, Отказ, ОповещениеЗавершения);
	Иначе 
		Если ОповещениеЗавершения <> Неопределено Тогда 
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Отказ);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ЗапроситьРежимИзмененияСостоянияВБраке(ФормаИсточник, ДатаИзменения, Отказ, ОповещениеЗавершения = Неопределено) Экспорт
	
	Если ФормаИсточник.ДоступенПросмотрДанныхФизическихЛиц Тогда
		
		ТекстКнопкиДа = НСтр("ru = 'Изменилось Состояние в браке'");
		ТекстВопроса = СтрШаблон(
				НСтр("ru =  'При редактировании изменены сведения о состоянии в браке. 
							|Если исправлена прежняя запись о семейном положении (она была ошибочной), нажмите ""Исправлена ошибка"".
							|Если у сотрудника изменилось семейное положение с %1, нажмите ""%2""'"), 
				Формат(ДатаИзменения, "ДФ='д ММММ гггг ""г""'"),
				ТекстКнопкиДа);
		
		РедактированиеПериодическихСведенийКлиент.ЗапроситьРежимИзмененияРегистра(ФормаИсточник, "СостоянияВБракеФизическихЛиц", ТекстВопроса, ТекстКнопкиДа, Отказ, ОповещениеЗавершения);
		
	Иначе 
		
		Если ОповещениеЗавершения <> Неопределено Тогда 
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗапроситьРежимИзмененияУдостоверенияЛичности(ФормаИсточник, ДатаИзменения, Отказ, ОповещениеЗавершения = Неопределено) Экспорт
	
	Если ФормаИсточник.ДоступенПросмотрДанныхФизическихЛиц Тогда
		
		ТекстКнопкиДа = НСтр("ru = 'Изменился документ, удостоверяющий личность'");
		ТекстВопроса = СтрШаблон(
				НСтр("ru =  'При редактировании изменены сведения о документе, удостоверяющем личность.
							|Если исправлена прежняя запись о документе (она была ошибочной), нажмите ""Исправлена ошибка"".
							|Если у сотрудника изменился документ, удостоверяющий личность с %1, нажмите'") + " ""%2""",
				Формат(ДатаИзменения, "ДФ='д ММММ гггг ""г""'"),
				ТекстКнопкиДа);
		
		РедактированиеПериодическихСведенийКлиент.ЗапроситьРежимИзмененияРегистра(ФормаИсточник, "ДокументыФизическихЛиц", ТекстВопроса, ТекстКнопкиДа, Отказ, ОповещениеЗавершения);
		
	Иначе 
		
		Если ОповещениеЗавершения <> Неопределено Тогда 
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Отказ);
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Просмотр истории

Процедура СотрудникиОткрытьФормуРедактированияИстории(ИмяРегистра, Форма) Экспорт
	ФизлицоЗаблокировано = ЗаблокироватьФизическоеЛицоПриРедактировании(Форма, Ложь);
	Если ИмяРегистра = "ДокументыФизическихЛиц" Тогда
		СотрудникиКлиентСервер.ОбновитьНаборЗаписейИсторииДокументыФизическихЛиц(Форма, Форма.ФизическоеЛицоСсылка);
	КонецЕсли;
	РедактированиеПериодическихСведенийКлиент.ОткрытьИсторию(ИмяРегистра, Форма.ФизическоеЛицоСсылка, Форма, Форма.ТолькоПросмотр ИЛИ НЕ ФизлицоЗаблокировано);
КонецПроцедуры

Процедура ОткрытьФормуРедактированияИстории(ИмяРегистра, ВедущийОбъект, Форма) Экспорт
	ТолькоПросмотрИстории = Форма.ТолькоПросмотр;
	Если Не ТолькоПросмотрИстории Тогда
		Попытка
			Форма.ЗаблокироватьДанныеФормыДляРедактирования();
			ТолькоПросмотрИстории = Ложь;
		Исключение
			ТолькоПросмотрИстории = Истина;
		КонецПопытки
	КонецЕсли; 
	Если ИмяРегистра = "ДокументыФизическихЛиц" Тогда
		СотрудникиКлиентСервер.ОбновитьНаборЗаписейИсторииДокументыФизическихЛиц(Форма, ВедущийОбъект);
	КонецЕсли;
	РедактированиеПериодическихСведенийКлиент.ОткрытьИсторию(ИмяРегистра, ВедущийОбъект, Форма, ТолькоПросмотрИстории);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Механизм встраивания форм

Процедура ЗарегистрироватьОткрытиеФормы(Форма, ИмяФормы) Экспорт
	
	Если ТипЗнч(Форма.ВладелецФормы.ОткрытыеФормы) <> Тип("Соответствие") Тогда
		Форма.ВладелецФормы.ОткрытыеФормы = Новый Соответствие;
	КонецЕсли; 
	
	Форма.ВладелецФормы.ОткрытыеФормы.Вставить(ИмяФормы, Форма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с дополнительными формами

Процедура ОткрытьДополнительнуюФорму(ОписаниеДополнительнойФормы, Форма) Экспорт
	
	ПараметрыФормы = ПараметрыДополнительнойФормы(ОписаниеДополнительнойФормы, Форма);
	ОткрытьФорму(ОписаниеДополнительнойФормы.ИмяФормы, ПараметрыФормы, Форма);
	
КонецПроцедуры

Функция ПараметрыДополнительнойФормы(ОписаниеДополнительнойФормы, Форма)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресВХранилище", "");
	
	Для каждого КлючевойРеквизит Из ОписаниеДополнительнойФормы.КлючевыеРеквизиты Цикл
		ПараметрыФормы.Вставить(КлючевойРеквизит.Ключ);
		Попытка
			Если ЗначениеЗаполнено(КлючевойРеквизит.Значение) Тогда
				Данные = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, КлючевойРеквизит.Значение);
				ПараметрыФормы[КлючевойРеквизит.Ключ] = Данные;
			КонецЕсли; 
		Исключение
		КонецПопытки;
	КонецЦикла;
	
	ЗаполнитьЗначенияСвойств(ПараметрыФормы, Форма);
	
	ПараметрыФормы.Вставить(
		"АдресВХранилище",
		Форма.АдресДанныхДополнительнойФормыНаСервере(ОписаниеДополнительнойФормы));
	
	Возврат ПараметрыФормы;
	
КонецФункции

Процедура УстановитьПризнакРедактированияДанныхВДополнительнойФорме(ИмяДополнительнойФормы, Форма) Экспорт
	
	ПрочитанныеДанные = Новый Соответствие;
	
	Если ТипЗнч(Форма.ПрочитанныеДанныеФорм) = Тип("ФиксированноеСоответствие") Тогда
		
		Для каждого ЭлементСтруктуры Из Форма.ПрочитанныеДанныеФорм Цикл
			ПрочитанныеДанные.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
		КонецЦикла;
		
	КонецЕсли;
	
	ПрочитанныеДанные.Вставить(ИмяДополнительнойФормы, Истина);
	
	Форма.ПрочитанныеДанныеФорм = Новый ФиксированноеСоответствие(ПрочитанныеДанные);
	Форма.Модифицированность = Истина;
	
КонецПроцедуры

#Область РаботаСПодбором

Процедура ОткрытьПодбор(ФормаВладелец, ИмяТабличнойЧасти) Экспорт
	
	ПараметрыПодбора = Новый Структура;
	Отказ = Ложь;
	
	ЗаполнитьЗначенияПараметровПодбора(ФормаВладелец, ИмяТабличнойЧасти, ПараметрыПодбора);
	
	Если НЕ Отказ Тогда
		ОписаниеОповещенияПриЗакрытииПодбора = Новый ОписаниеОповещения("ПриЗакрытииПодбора", СотрудникиКлиент.ЭтотОбъект);
		ОткрытьФорму("Обработка.ПодборСотрудника.Форма.Корзина", 
			ПараметрыПодбора, ФормаВладелец, Истина, , , ОписаниеОповещенияПриЗакрытииПодбора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

// Процедура обработки результатов закрытия подбора
//
Процедура ПриЗакрытииПодбора(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		Если НЕ ПустаяСтрока(РезультатЗакрытия.АдресКорзиныВХранилище) Тогда
			Оповестить("ПодборСотрудникаПроизведен", РезультатЗакрытия.АдресКорзиныВХранилище, РезультатЗакрытия.УникальныйИдентификаторФормыВладельца);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПриЗакрытииПодбора()

// Получение данных из форм-владельцев

Процедура ЗаполнитьЗначенияПараметровПодбора(ФормаВладелец, ИмяТабличнойЧасти, ПараметрыПодбора)
	
	ПараметрыПодбора.Вставить("Организация", ФормаВладелец.ЭтотОбъект.Объект.Организация);
	ПараметрыПодбора.Вставить("Дата", ФормаВладелец.ДатаДокумента);
	ПараметрыПодбора.Вставить("УникальныйИдентификаторФормыВладельца", ФормаВладелец.УникальныйИдентификатор);
	
	ЗаполнитьПараметрПодразделение(ФормаВладелец, ПараметрыПодбора);
	ЗаполнитьСписокПодобранных(ФормаВладелец, ПараметрыПодбора, ИмяТабличнойЧасти);
	ЗаполнитьДополнительныеПараметры(ФормаВладелец, ПараметрыПодбора);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрПодразделение(ФормаВладелец, ПараметрыПодбора)
	Перем Подразделение;
	
	ФормаВладелец.ЭтотОбъект.Объект.Свойство("Подразделение", Подразделение);
	ПараметрыПодбора.Вставить("Подразделение", Подразделение);
	
КонецПроцедуры

Процедура ЗаполнитьДополнительныеПараметры(ФормаВладелец, ПараметрыПодбора)
	
	ПоказыватьУволенных = Ложь;
	ПараметрыПодбора.Вставить("ПоказыватьУволенных", ПоказыватьУволенных);			
КонецПроцедуры

Процедура ЗаполнитьСписокПодобранных(ФормаВладелец, ПараметрыПодбора, ИмяТабличнойЧасти)
	СписокПодобранных = Новый СписокЗначений;
	Для Каждого СтрокаТабличнойЧасти Из ФормаВладелец.Объект[ИмяТабличнойЧасти] Цикл 
		СписокПодобранных.Добавить(СтрокаТабличнойЧасти.ФизЛицо);
	КонецЦикла;
	
	ПараметрыПодбора.Вставить("СписокПодобранных", СписокПодобранных);		
КонецПроцедуры

// Конец Получение данных из форм-владельцев

#КонецОбласти
