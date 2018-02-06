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
	
	Подразделение = Объект.Подразделение;

	Если Не ЗначениеЗаполнено(Объект.ПериодРегистрации) Тогда 
		Объект.ПериодРегистрации = НачалоМесяца(ДатаДокумента);
	КонецЕсли;	
	
	СписокДокументовВыплаты.Параметры.УстановитьЗначениеПараметра("ДокументОснование", Объект.Ссылка);

	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой");
	
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
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой");

	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПодборСотрудникаПроизведен" 
		И ЗначениеЗаполнено(Параметр) 
		// Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		АдресЗапасовВХранилище = Параметр;
		ПолучитьРезультатПодбораИзХранилища(АдресЗапасовВХранилище, "Зарплата");
	ИначеЕсли ИмяСобытия = "ОповеститьОСозданииНаОснованииВедомостьЗП" Тогда
		СписокДокументовВыплаты.Параметры.УстановитьЗначениеПараметра("ДокументОснование", Объект.Ссылка);
		Элементы.СписокДокументовВыплаты.Обновить();	
	КонецЕсли;
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
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
КонецПроцедуры

//Процедура - обработчик события ПриИзменении поля ввода БанковскийСчет
//
&НаКлиенте
Процедура БанковскийСчетПриИзменении(Элемент)
	ПересчитатьОстаткиПоКассеИлиБанковскомуСчету(Ложь);
КонецПроцедуры

//Процедура - обработчик события ПриИзменении поля ввода Касса
//
&НаКлиенте
Процедура КассаПриИзменении(Элемент)
	ПересчитатьОстаткиПоКассеИлиБанковскомуСчету(Истина);
КонецПроцедуры

//Процедура - обработчик события ПриИзменении поля ввода ПоБанковскимСчетам
//
&НаКлиенте
Процедура ПоБанковскимСчетамПриИзменении(Элемент)
	УстановитьВидимостьДоступностьЭлементов();
	ОчисткаСуммТабличнойЧастиЗарплата("СуммаПоБанковскомуСчету");
КонецПроцедуры

//Процедура - обработчик события ПриИзменении поля ввода ПоЗППроект
//
&НаКлиенте
Процедура ПоЗППроектПриИзменении(Элемент)
	УстановитьВидимостьДоступностьЭлементов();
	ОчисткаСуммТабличнойЧастиЗарплата("СуммаПоКартСчету");
КонецПроцедуры

//Процедура - обработчик события ПриИзменении поля ввода ПоКассе
//
&НаКлиенте
Процедура ПоКассеПриИзменении(Элемент)
	УстановитьВидимостьДоступностьЭлементов();
	ОчисткаСуммТабличнойЧастиЗарплата("СуммаПоКассе");
КонецПроцедуры

//Процедура - обработчик события ПриИзменении поля ввода ПоАвансовомуОтчету
//
&НаКлиенте
Процедура ПоАвансовомуОтчетуПриИзменении(Элемент)
	УстановитьВидимостьДоступностьЭлементов();
	ОчисткаСуммТабличнойЧастиЗарплата("СуммаПоАвансовомуОтчету");
КонецПроцедуры

//Процедура - обработчик события ПриИзменении поля ввода Подразделение
//
&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	// Значение реквизита не изменилось
	Если Объект.Подразделение = Подразделение Тогда 
		Возврат;
	КонецЕсли;	

	Если Объект.Зарплата.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросОчиститьТабличнуюЧастьЗарплата", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена. Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе 
		Подразделение = Объект.Подразделение;
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТабличнойЧастиЗарплата

&НаКлиенте
Процедура ЗарплатаПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если ОтменаРедактирования 
		Или Отказ Тогда 
		Возврат;
	КонецЕсли;
	
	СтрокаТабличнойЧасти = Элемент.ТекущиеДанные;
	СтрокаТабличнойЧасти.РучнаяКорректировка = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ПересчитатьТаблицуВыплат();
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаПослеУдаления(Элемент)
	ПересчитатьТаблицуВыплат();
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаКартСчетПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Зарплата.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.КартСчет) Тогда
		УстановитьБанкКартСчетаИлиБанковскогоСчетаВСтроке(СтрокаТабличнойЧасти.БанкКартСчета, СтрокаТабличнойЧасти.КартСчет);
	Иначе
		СтрокаТабличнойЧасти.СуммаПоКартСчету = 0;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаБанковскийСчетПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Зарплата.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.БанковскийСчет) Тогда
		УстановитьБанкКартСчетаИлиБанковскогоСчетаВСтроке(СтрокаТабличнойЧасти.БанкБанковскийСчет, СтрокаТабличнойЧасти.БанковскийСчет);
	Иначе
		СтрокаТабличнойЧасти.СуммаПоБанковскомуСчету = 0;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаСуммаПоБанковскомуСчетуПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Зарплата.ТекущиеДанные;
	
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.БанковскийСчет) Тогда
		СтрокаТабличнойЧасти.СуммаПоБанковскомуСчету = 0;
		ТекстСообщения = НСтр("ru = 'Не выбран банковский счет сотруднкика!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,)
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗарплатаСуммаПоКартСчетуПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Зарплата.ТекущиеДанные;
	
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.КартСчет) Тогда
		СтрокаТабличнойЧасти.СуммаПоКартСчету = 0;
		ТекстСообщения = НСтр("ru = 'Не выбран карт счет сотруднкика!'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,)
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДокументовВыплаты

&НаКлиенте
Процедура СписокДокументовВыплатыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)	
	ДокументМенеджер = ДанныеДинамическогоСписка("СписокДокументовВыплатыВыбор", ВыбраннаяСтрока);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Элемент.ТекущиеДанные.Ссылка);
	ОткрытьФорму(ДокументМенеджер + ".ФормаОбъекта", ПараметрыФормы, Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоОстаткам(Команда)
	
	Отказ = ПроверкаЗаполненияПередИсполнениемКоманды("Заполнить");
	
	Если Отказ Тогда 
		Возврат
	КонецЕсли;		
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВидЗаполненияТабличнойЧасти", Команда.Имя);	
	Если Объект.Зарплата.Количество() > 0 Тогда

		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличнуюЧасть", ЭтотОбъект, ДополнительныеПараметры);
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ЗаполнитьТабличнуюЧастьНаСервере(ДополнительныеПараметры);
		
		Если Объект.Зарплата.Количество() = 0 Тогда 
			ТекстСообщения = НСтр("ru = 'Нет данных для заполнения.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Зарплата")
		Иначе
			ТекстОповещения = НСтр("ru = 'Заполнение'");
			ТекстПояснения = НСтр("ru = 'Табличная часть заполнена'");
			ПоказатьОповещениеПользователя(ТекстОповещения,, ТекстПояснения, БиблиотекаКартинок.Информация32);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОстаткамЗаМесяц(Команда)

	Отказ = ПроверкаЗаполненияПередИсполнениемКоманды("Заполнить");
	
	Если Отказ Тогда 
		Возврат
	КонецЕсли;	
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВидЗаполненияТабличнойЧасти", Команда.Имя);	
	Если Объект.Зарплата.Количество() > 0 Тогда

		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличнуюЧасть", ЭтотОбъект, ДополнительныеПараметры);
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ЗаполнитьТабличнуюЧастьНаСервере(ДополнительныеПараметры);
		
		Если Объект.Зарплата.Количество() = 0 Тогда 
			ТекстСообщения = НСтр("ru = 'Нет данных для заполнения.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Зарплата")
		Иначе
			ТекстОповещения = НСтр("ru = 'Заполнение'");
			ТекстПояснения = НСтр("ru = 'Табличная часть заполнена'");
			ПоказатьОповещениеПользователя(ТекстОповещения,, ТекстПояснения, БиблиотекаКартинок.Информация32);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборСотрудников(Команда)
	СотрудникиКлиент.ОткрытьПодбор(ЭтаФорма, "Зарплата");
КонецПроцедуры

&НаКлиенте
Процедура СформироватьДокументыВыплаты(Команда)
	
	Отказ = ПроверкаЗаполненияПередИсполнениемКоманды("СформироватьДокументыВыплаты");	
		
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗаписатьДокументОтменивПроведение() Тогда 
		Возврат;
	КонецЕсли;
	
	СформироватьДокументыВыплатыНаСервере();
	УстановитьВидимостьДоступностьЭлементов();
	
	ТекстОповещения = НСтр("ru = 'Создание'");
	ТекстПояснения = НСтр("ru = 'Документы выплаты созданы'");
	ПоказатьОповещениеПользователя(ТекстОповещения,, ТекстПояснения, БиблиотекаКартинок.Информация32);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьТабличнуюЧасть(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.Зарплата.Очистить();
		Объект.ТаблицаВыплат.Очистить();
		ЗаполнитьТабличнуюЧастьНаСервере(ДополнительныеПараметры);
		
		Если Объект.Зарплата.Количество() = 0 Тогда 
			ТекстСообщения = НСтр("ru = 'Нет данных для заполнения.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.Зарплата")
		Иначе
			ТекстОповещения = НСтр("ru = 'Заполнение'");
			ТекстПояснения = НСтр("ru = 'Табличная часть заполнена'");
			ПоказатьОповещениеПользователя(ТекстОповещения,, ТекстПояснения, БиблиотекаКартинок.Информация32);
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры	

&НаКлиенте
Процедура ОтветНаВопросОчиститьТабличнуюЧастьЗарплата(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Подразделение = Объект.Подразделение;
		Объект.Зарплата.Очистить();
		Объект.ТаблицаВыплат.Очистить();
	Иначе
		// Отмена изменения - возврат прежних значений
		Объект.Подразделение = Подразделение;     
	КонецЕсли; 
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
// Процедура вызывает процедура модуля объекта для заполнения ТЧ "Зарплата".
//
// Параметры:
//	НаименованиеКолонки - Строка, название колонки, которую необходимо очистить.
//
Процедура ОчисткаСуммТабличнойЧастиЗарплата(НаименованиеКолонки)

	Для каждого СтрокаТабличнойЧасти Из Объект.Зарплата Цикл
		Если НаименованиеКолонки = "СуммаПоБанковскомуСчету" Тогда
			СтрокаТабличнойЧасти.СуммаПоБанковскомуСчету = 0;
			
		ИначеЕсли НаименованиеКолонки = "СуммаПоКартСчету" Тогда
			СтрокаТабличнойЧасти.СуммаПоКартСчету = 0;
			
		ИначеЕсли НаименованиеКолонки = "СуммаПоКассе" Тогда
			СтрокаТабличнойЧасти.СуммаПоКассе = 0;
			
		Иначе
			СтрокаТабличнойЧасти.СуммаПоАвансовомуОтчету = 0;
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры

&НаСервере
// Процедура вызывает процедура модуля объекта для заполнения ТЧ "Зарплата".
//
// Параметры:
//	Банк - Справочники.Банки, ссылка на банк.
//
//	Счет - Справочники.КартСчетаСотрудников, Справочники.БанковскиеСчета, ссылка на карт счет или банковский счет.
//
Процедура УстановитьБанкКартСчетаИлиБанковскогоСчетаВСтроке(Банк, Счет)
	Банк = Счет.Банк;		
КонецПроцедуры

&НаСервере
// Процедура пересчитывает ТЧ "ТаблицаВыплат" при изменениях в ТЧ "Зарплата".
//
Процедура ПересчитатьТаблицуВыплат()

	Объект.ТаблицаВыплат.Очистить();
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДополнительныеСвойства.Вставить("ПериодРегистрации", Объект.ПериодРегистрации);
	
	ТЗ = Объект.Зарплата.Выгрузить();
	
	Если Объект.ПоЗППроект Тогда
		Документ.ЗаполнитьТаблицуВыплатПоЗППроектам(ТЗ);
	КонецЕсли;
	
	Если Объект.ПоБанковскимСчетам Тогда
		Документ.ЗаполнитьТаблицуВыплатПоБанковскимСчетам(ТЗ.Итог("СуммаПоБанковскомуСчету"));
	КонецЕсли;
	
	Если Объект.ПоКассе Тогда
		Документ.ЗаполнитьТаблицуВыплатПоКассе(ТЗ.Итог("СуммаПоКассе"));
	КонецЕсли;	

	ЗначениеВРеквизитФормы(Документ, "Объект");
	
	Если Объект.ПоАвансовомуОтчету Тогда
		ИтогПоАО = ТЗ.Итог("СуммаПоАвансовомуОтчету");
		
		Если ИтогПоАО <> 0 Тогда
			СтрокаТабличнойЧасти = Объект.ТаблицаВыплат.Добавить();
			СтрокаТабличнойЧасти.Наименование = "Авансовый отчет"; 
			СтрокаТабличнойЧасти.Сумма 		  = ТЗ.Итог("СуммаПоАвансовомуОтчету");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Процедура вызывает процедура модуля объекта для заполнения ТЧ "Зарплата".
//
// Параметры:
//	ПересчитатьОстатокПоКассе - Булево, признак для определения по кассе или банковскому счету 
//										необходимо перечститать сумму остаток.
//
Процедура ПересчитатьОстаткиПоКассеИлиБанковскомуСчету(ПересчитатьОстатокПоКассе)
	
	Документ = РеквизитФормыВЗначение("Объект");
	СуммаОстатка = Документ.ПолучитьОстатокПоКассеИлиБанковскомуСчету(ПересчитатьОстатокПоКассе);	
	ЗначениеВРеквизитФормы(Документ, "Объект");
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.ТаблицаВыплат Цикл
		Если ПересчитатьОстатокПоКассе Тогда
			Если СтрокаТабличнойЧасти.Наименование = "Касса" Тогда
				СтрокаТабличнойЧасти.СуммаОстаток = СуммаОстатка;
				Прервать;
			КонецЕсли;
		Иначе
			Если НЕ СтрокаТабличнойЧасти.Наименование = "Касса" И НЕ СтрокаТабличнойЧасти.Наименование = "Авансовый отчет" Тогда
				СтрокаТабличнойЧасти.СуммаОстаток = СуммаОстатка;
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Процедура устанавливает видимость и доступность элементов.
//
&НаКлиенте
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Элементы.Касса.Видимость 					  	   = Ложь;
	Элементы.БанковскийСчет.Видимость			  	   = Ложь;
	Элементы.СпособВыплаты.Видимость			  	   = Ложь;
	Элементы.ЗарплатаБанковскийСчет.Видимость		   = Ложь;
	Элементы.ЗарплатаСуммаПоБанковскомуСчету.Видимость = Ложь;
	Элементы.ЗарплатаКартСчет.Видимость		  		   = Ложь;
	Элементы.ЗарплатаСуммаПоКартСчету.Видимость		   = Ложь;
	Элементы.ЗарплатаСуммаПоКассе.Видимость		  	   = Ложь;
	Элементы.ЗарплатаСуммаПоАвансовомуОтчету.Видимость = Ложь;
	
	Элементы.ЗарплатаПодразделение.Видимость = Объект.Подразделение.Пустая();
	
	КоличествоСозданныхДокументов = ДанныеДинамическогоСписка("УстановитьВидимостьДоступностьЭлементов");
	
	Если КоличествоСозданныхДокументов > 0 Тогда
		Элементы.СформироватьДокументыВыплаты.Видимость = Ложь;
	Иначе
		Элементы.СформироватьДокументыВыплаты.Видимость = Истина;
	КонецЕсли;

	Если Объект.ПоБанковскимСчетам Тогда
		Элементы.БанковскийСчет.Видимость 				   = Истина;
		Элементы.ЗарплатаБанковскийСчет.Видимость		  	   = Истина;
		Элементы.ЗарплатаСуммаПоБанковскомуСчету.Видимость = Истина;
	КонецЕсли;
	
	Если Объект.ПоКассе Тогда
		Элементы.Касса.Видимость 		  		= Истина;
		Элементы.СпособВыплаты.Видимость 		= Истина;
		Элементы.ЗарплатаСуммаПоКассе.Видимость	= Истина;
	КонецЕсли;
	
	Если Объект.ПоЗППроект Тогда
		Элементы.ЗарплатаКартСчет.Видимость		  	= Истина;
		Элементы.ЗарплатаСуммаПоКартСчету.Видимость	= Истина;
	КонецЕсли;
	
	Если Объект.ПоАвансовомуОтчету Тогда
		Элементы.ЗарплатаСуммаПоАвансовомуОтчету.Видимость = Истина;
	КонецЕсли;
		
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

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

// Функция возвращает ответ пользователя о возможности записи/отмене проведения документа перед рассчетом
//
// Параметры:
//  Действие  - Строка - действие, при котором выполняется проверка
// Возвращаемое значение:
//   Булево - 
//
&НаКлиенте
Функция ЗаписатьДокументОтменивПроведение()
	Если Объект.Проведен Тогда
		ЗаписатьНаСервере(РежимЗаписиДокумента.ОтменаПроведения);		
	ИначеЕсли Модифицированность 
		Или ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Дата = ДатаДокумента;
		ЗаписатьНаСервере(РежимЗаписиДокумента.Запись);
		СписокДокументовВыплаты.Параметры.УстановитьЗначениеПараметра("ДокументОснование", Объект.Ссылка);
	КонецЕсли;	
	
	Возврат Истина;
КонецФункции // ЗаписатьДокументОтменивПроведение()

&НаСервере
Процедура ЗаписатьНаСервере(Режим)
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.Записать(Режим);
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры // ЗаписатьНаСервере()

&НаСервере
// Процедура вызывает процедура модуля объекта для заполнения ТЧ "Зарплата".
//
// Параметры:
//	ДополнительныеПараметры - Структура, необходимые данные для отборов при заполнении.
//
Процедура ЗаполнитьТабличнуюЧастьНаСервере(ДополнительныеПараметры)
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДополнительныеСвойства.Вставить("ВидЗаполненияТабличнойЧасти", ДополнительныеПараметры.ВидЗаполненияТабличнойЧасти);
	Документ.ДополнительныеСвойства.Вставить("ПериодРегистрации", 			Объект.ПериодРегистрации);
	Документ.ЗаполнитьТабличнуюЧасть();                           	
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры // ЗаполнитьТабличнуюЧастьНаСервере()

// Процедура получает результат подбора из временного хранилища
//
&НаСервере
Процедура ПолучитьРезультатПодбораИзХранилища(АдресЗапасовВХранилище, ИмяТабличнойЧасти)
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	
	МассивФизЛиц = Новый Массив;
	
	Для Каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл
		НайденныеСтроки = Объект[ИмяТабличнойЧасти].НайтиСтроки(Новый Структура("ФизЛицо", СтрокаЗагрузки.ФизЛицо));
		
		Если НайденныеСтроки.Количество() > 0 Тогда 
			Продолжить;
		КонецЕсли;	
		
		СтрокаТабличнойЧасти = Объект[ИмяТабличнойЧасти].Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаЗагрузки);
		МассивФизЛиц.Добавить(СтрокаТабличнойЧасти.ФизЛицо);
	КонецЦикла;
КонецПроцедуры // ПолучитьЗапасыИзХранилища()

// Функция проверяет наличие значений определенных реквизитов по условиям.
// 
// Возвращаемое значение:
//		Отказ - булево, для отмены исполнения команд, если не заполнены определенные реквизиты.
//
&НаСервере
Функция ПроверкаЗаполненияПередИсполнениемКоманды(НаименованиеКоманды)

	Отказ = Ложь;
	
	Если НаименованиеКоманды = "СформироватьДокументыВыплаты" Тогда		
		Если Объект.Зарплата.Количество() = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Табличная часть ""Зарплата"" пустая! Создание документов отменено.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Зарплата",,Отказ)
		КонецЕсли;
		
		Если Объект.ПоКассе И Объект.СпособВыплаты = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Не выбран способ формирования для расходного кассового ордера! Создание документов отменено.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.СпособВыплаты",,Отказ)	
		КонецЕсли;
		
		СтруктураОтбор = Новый Структура();
		СтруктураОтбор.Вставить("СуммаПоБанковскомуСчету", 0);
		СтруктураОтбор.Вставить("СуммаПоКартСчету", 0);
		СтруктураОтбор.Вставить("СуммаПоКассе", 0);
		СтруктураОтбор.Вставить("СуммаПоАвансовомуОтчету", 0);
		
		Если Объект.Зарплата.НайтиСтроки(СтруктураОтбор).Количество() > 0 Тогда
			ТекстСообщения = НСтр("ru = 'В табличной части ""Зарплата"" есть строка(и) с незаполненными суммами! Создание документов отменено.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Зарплата",,Отказ)	
		КонецЕсли;
	КонецЕсли;
		
	Если НЕ ЗначениеЗаполнено(Объект.ПериодРегистрации) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнен период! Заполнение документа отменено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "МесяцСтрокой",,Отказ)		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ПорядокОкругления) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнено поле Порядок округления! Заполнение документа отменено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.ПорядокОкругления",,Отказ)		
	КонецЕсли;
	
	Если НЕ Объект.ПоБанковскимСчетам И НЕ Объект.ПоЗППроект И НЕ Объект.ПоКассе И НЕ Объект.ПоАвансовомуОтчету Тогда
		ТекстСообщения = НСтр("ru = 'Не выбран ни один способ выплат! Заполнение документа отменено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ)		
	КонецЕсли;
	
	Если Объект.ПоБанковскимСчетам И НЕ ЗначениеЗаполнено(Объект.БанковскийСчет) Тогда
		ТекстСообщения = НСтр("ru = 'Выбран способ выплат по банковским счетам, но не заполнен банковский счет! Заполнение документа отменено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.БанковскийСчет",,Отказ)		
	КонецЕсли;
	
	Если Объект.ПоКассе И НЕ ЗначениеЗаполнено(Объект.Касса) Тогда
		ТекстСообщения = НСтр("ru = 'Выбран способ выплат по кассе, но не заполнена касса! Заполнение документа отменено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Касса",,Отказ)		
	КонецЕсли;
	
	Возврат Отказ;
КонецФункции

// Функция считывает данные динамического списка.
//
// Параметры:
//  ПроцедураОбращения - Строка - название процедуры обращения к функции.
//  ВыбраннаяСтрока - Число - номер выбираемой строки в динамичеком списке.
//
// Возвращаемое значение:
//		Если ВыбраннаяСтрока = Неопределено Тогда
//			Результат.Количество() - Число, количество строк в динамическом списке.
//		Иначе
//			ДокументМенеджер - Строка, название документа, для создания.
//
&НаСервере
Функция ДанныеДинамическогоСписка(ПроцедураОбращения, ВыбраннаяСтрока = Неопределено)
	
	Схема = Элементы.СписокДокументовВыплаты.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.СписокДокументовВыплаты.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Если ПроцедураОбращения = "УстановитьВидимостьДоступностьЭлементов" Тогда
		Возврат Результат.Количество();
	ИначеЕсли ПроцедураОбращения = "СписокДокументовВыплатыВыбор" Тогда		
		ВыбраннаяСтрока = ВыбраннаяСтрока - 1;	
		Если ТипЗнч(Результат[ВыбраннаяСтрока].Ссылка) = Тип("ДокументСсылка.ПлатежноеПоручениеИсходящее") Тогда
			ДокументМенеджер = "Документ.ПлатежноеПоручениеИсходящее";
		Иначе
			ДокументМенеджер = "Документ.РасходныйКассовыйОрдер";
		КонецЕсли;
		
		Возврат ДокументМенеджер;
	КонецЕсли;		
КонецФункции

// Процедура подготавливает данные для создания документов выплаты.
//
&НаСервере
Процедура СформироватьДокументыВыплатыНаСервере()
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ПодготовитьДанныеДляДокументовВыплаты();                           	
	ЗначениеВРеквизитФормы(Документ, "Объект");
	Элементы.СписокДокументовВыплаты.Обновить();
	
КонецПроцедуры

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

#Область РедактированиеМесяцаСтрокой

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

