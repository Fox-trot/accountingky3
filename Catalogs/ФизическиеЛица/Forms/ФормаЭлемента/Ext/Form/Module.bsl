﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ОткрытыеФормы Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

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
	
	Дата = ТекущаяДатаСеанса();
	
	СотрудникиФормы.ФизическиеЛицаПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ПриказыКадровые.Параметры.УстановитьЗначениеПараметра("ФизЛицо", ФизическоеЛицоСсылка);	
	ИсполнительныйЛист.Параметры.УстановитьЗначениеПараметра("ФизЛицо", ФизическоеЛицоСсылка);		

	Если СозданиеНового Тогда 
		ГражданствоПоУмолчанию();
	Иначе 
		ДатаУвольнения = ДатаУвольненияСотрудника(ТекущаяДатаСеанса(), ФизическоеЛицоСсылка);		
	КонецЕсли;
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтаФорма, ФизЛицо, "ГруппаКонтактнаяИнформация");	
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация	
		
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = УправлениеСвойствамиПереопределяемый.ЗаполнитьДополнительныеПараметры(ФизЛицо, "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ОтложеннаяИнициализация", Истина);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Не ЗначениеЗаполнено(ДатаУвольнения) Тогда 
		КонецПериода = КонецДня(Дата);
	Иначе 
		КонецПериода = ДатаУвольнения;
	КонецЕсли;
	
	ПроверитьИНН();

	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	СотрудникиКлиент.ФизическиеЛицаОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	СотрудникиФормы.ФизическиеЛицаПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация 
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Не ПараметрыЗаписи.Свойство("ПроверкаПередЗаписьюВыполнена") Тогда 
		Отказ = Истина;
		ЗаписатьНаКлиенте(Ложь);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ФизЛицо.Ссылка = Справочники.ФизическиеЛица.ПустаяСсылка() Тогда 
		Ссылка = Справочники.ФизическиеЛица.ПолучитьСсылку(Новый УникальныйИдентификатор);
	Иначе
		Ссылка = ФизЛицо.Ссылка;
	КонецЕсли;
	
	Справочники.ФизическиеЛица.ПроверитьДублиИНН(ФизЛицо.ИНН, Ссылка);
	
	Если Не ЗначениеЗаполнено(ФизЛицо.ФИО) Тогда 
		ФизЛицо.ФИО = ФизЛицо.Наименование;
	КонецЕсли;
	
	СотрудникиФормы.ФизическиеЛицаПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	СотрудникиФормы.ФизическиеЛицаПриЗаписиНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);	
	
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	СотрудникиФормы.ФизическиеЛицаПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	СотрудникиКлиент.ФизическиеЛицаПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// Гражданство.
	Если ЗначениеЗаполнено(ГражданствоФизическихЛиц.Страна)
		И НЕ ЗначениеЗаполнено(ГражданствоФизическихЛиц.Период) Тогда 
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Период (Гражданство)'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ГражданствоФизическихЛиц.Период",, Отказ);
	КонецЕсли;	
	
	// Документ, удостоверяющий личность.
	Если ЗначениеЗаполнено(ДокументыФизическихЛиц.ВидДокумента)
		И НЕ ЗначениеЗаполнено(ДокументыФизическихЛиц.Период) Тогда 
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'Период (Документы)'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ДокументыФизическихЛиц.Период",, Отказ);
	КонецЕсли;	
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, ФизЛицо, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты, ФизЛицо);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если Модифицированность Тогда
		Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьНаКлиенте", ЭтотОбъект);
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	КонецЕсли;                                                                         
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗакладкиПриСменеСтраницы(Элемент, ТекущаяСтраница)
	// СтандартныеПодсистемы.Свойства
	Если ЭтотОбъект.ПараметрыСвойств.Свойство(ТекущаяСтраница.Имя)
		И Не ЭтотОбъект.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация Тогда
		
		СвойстваВыполнитьОтложеннуюИнициализацию();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

// Процедура - обработчик события ПриИзменении реквизита ИНН
//
&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	ПроверитьИНН();
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////
// Редактирование данных ФизическогоЛица

&НаКлиенте
Процедура ФизическоеЛицоМестоРожденияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СотрудникиКлиент.ФизическиеЛицаМестоРожденияНачалоВыбора(ЭтаФорма, Элемент, СтандартнаяОбработка, ФизЛицо.МестоРождения);
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ФизлицоДатаРождения.
//
&НаКлиенте
Процедура ФизлицоДатаРожденияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(ФизЛицо.ДатаРождения) Тогда 
		ГодМолодости = Год(Дата) - 15;
		ГодСтарости  = Год(Дата) - 150;
		
		Если Год(ФизЛицо.ДатаРождения) > ГодМолодости 
			Или Год(ФизЛицо.ДатаРождения) < ГодСтарости Тогда
			ТекстСообщения = НСтр("ru = 'Дата рождения выходит за границы допустимого диапозона.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ФизическоеЛицоСсылка, "ДатаРождения", "ФизЛицо");
			ФизЛицо.ДатаРождения = '00010101000000';	
		КонецЕсли;
	КонецЕсли;
	
	ПроверитьИНН();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ГражданствоФизическихЛицСтрана.
//
&НаКлиенте
Процедура ГражданствоФизическихЛицСтранаПриИзменении(Элемент)
	Если ГражданствоФизическихЛиц.Период = '00010101' Тогда
		ГражданствоФизическихЛиц.Период = НачалоДня(ЗарплатаКадрыКлиентСервер.ДатаСеанса())
	КонецЕсли;
	
	ПроверитьИНН();
КонецПроцедуры

&НаСервере
Процедура ГражданствоПоУмолчанию()
	ГражданствоФизическихЛиц.Страна = Справочники.СтраныМира.Киргизия;
	ГражданствоФизическихЛиц.Период = Дата; 
	
	ДокументыФизическихЛиц.ВидДокумента = Справочники.ВидыДокументовФизическихЛиц.Паспорт;
	ДокументыФизическихЛиц.ДатаВыдачи = Дата;
	ДокументыФизическихЛиц.СрокДействия = Дата;
	ДокументыФизическихЛиц.Период = Дата;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ДокументыФизическихЛицВидДокумента.
//
&НаКлиенте
Процедура ДокументыФизическихЛицВидДокументаПриИзменении(Элемент)
	СотрудникиКлиент.ДокументыФизическихЛицВидДокументаПриИзменении(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицВидДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СотрудникиКлиент.ДокументыФизическихЛицВидДокументаНачалоВыбора(ЭтаФорма, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ДокументыФизическихЛицДатаВыдачи.
//
&НаКлиенте
Процедура ДокументыФизическихЛицДатаВыдачиПриИзменении(Элемент)
	СотрудникиКлиент.ДокументыФизическихЛицВидДокументаПриИзменении(ЭтаФорма);
	
	ДатаВыдачи = ДокументыФизическихЛиц.ДатаВыдачи;
	Если ЗначениеЗаполнено(ДатаВыдачи) Тогда 	                                                   
		Если Год(ДатаВыдачи) < Год(Дата) - 100 Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Некорректная дата выдачи удостоверения",ФизическоеЛицоСсылка,"ДатаВыдачи","ДокументыФизическихЛиц");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ДокументыФизическихЛицСрокДействия.
//
&НаКлиенте
Процедура ДокументыФизическихЛицСрокДействияПриИзменении(Элемент)
	СрокДействия = ДокументыФизическихЛиц.СрокДействия;
	Если ЗначениеЗаполнено(СрокДействия) Тогда 	                                                   
		Если Год(СрокДействия) > Год(Дата) + 10 или  Год(СрокДействия) < Год(Дата) - 100 Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Некорректный срок действия удостоверения",ФизическоеЛицоСсылка,"СрокДействия","ДокументыФизическихЛиц");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУченыеСтепени

// Процедура - обработчик события ПриИзменении поля ввода УченыеСтепениФизическихЛицНаборЗаписей.
//
&НаКлиенте
Процедура УченыеСтепениФизическихЛицНаборЗаписейПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура УченыеСтепениФизическихЛицНаборЗаписейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Элемент.ТекущиеДанные.ФизЛицо = ФизическоеЛицоСсылка;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУченыеЗвания

// Процедура - обработчик события ПриИзменении поля ввода УченыеЗванияФизическихЛицНаборЗаписей.
//
&НаКлиенте
Процедура УченыеЗванияФизическихЛицНаборЗаписейПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура УченыеЗванияФизическихЛицНаборЗаписейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Элемент.ТекущиеДанные.ФизЛицо = ФизическоеЛицоСсылка;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВоинскийУчет

// Процедура - обработчик события ПриИзменении поля ввода ВоинскийУчетФизическихЛицНаборЗаписей.
//
&НаКлиенте
Процедура ВоинскийУчетФизическихЛицНаборЗаписейПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВоинскийУчетФизическихЛицНаборЗаписейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Элемент.ТекущиеДанные.ФизЛицо = ФизическоеЛицоСсылка;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТрудоваяДеятельность

// Процедура - обработчик события ПриИзменении поля ввода ТрудоваяДеятельностьФизическихЛицНаборЗаписей.
//
&НаКлиенте
Процедура ТрудоваяДеятельностьФизическихЛицНаборЗаписейПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТрудоваяДеятельностьФизическихЛицНаборЗаписейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Элемент.ТекущиеДанные.ФизЛицо = ФизическоеЛицоСсылка;
	ТрудоваяДеятельностьФизическихЛицНаборЗаписей.Сортировать("ДатаНачала");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОбразованиеФизическихЛиц

// Процедура - обработчик события ПриИзменении поля ввода ОбразованиеФизическихЛицНаборЗаписей.
//
&НаКлиенте
Процедура ОбразованиеФизическихЛицНаборЗаписейПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОбразованиеФизическихЛицНаборЗаписейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Элемент.ТекущиеДанные.ФизЛицо = ФизическоеЛицоСсылка;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗнаниеЯзыков

// Процедура - обработчик события ПриИзменении поля ввода ЗнаниеЯзыковФизическихЛицНаборЗаписей.
//
&НаКлиенте
Процедура ЗнаниеЯзыковФизическихЛицНаборЗаписейПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗнаниеЯзыковФизическихЛицНаборЗаписейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Элемент.ТекущиеДанные.ФизЛицо = ФизическоеЛицоСсылка;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСоставыСемей

// Процедура - обработчик события ПриИзменении поля ввода СоставыСемейФизическихЛицНаборЗаписей.
//
&НаКлиенте
Процедура СоставыСемейФизическихЛицНаборЗаписейПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СоставыСемейФизическихЛицНаборЗаписейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Элемент.ТекущиеДанные.ФизЛицо = ФизическоеЛицоСсылка;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНаградыФизическихЛиц

&НаКлиенте
Процедура НаградыФизическихЛицНаборЗаписейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Элемент.ТекущиеДанные.ФизЛицо = ФизическоеЛицоСсылка;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСостоянияВБраке

// Процедура - обработчик события ПриИзменении поля ввода СостоянияВБракеФизическихЛицСостояниеВБраке.
//
&НаКлиенте
Процедура СостоянияВБракеФизическихЛицСостояниеВБракеПриИзменении(Элемент)
	СостоянияВБракеФизическихЛицСостояниеВБракеПриИзмененииНаСервере();
	Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ФИОФизическихЛицИстория(Команда)
	СотрудникиКлиент.ОткрытьФормуРедактированияИстории("ФИОФизическихЛиц", ФизическоеЛицоСсылка, ЭтаФорма);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ФИО.
//
&НаКлиенте
Процедура ФИОПриИзменении(Элемент)
	СотрудникиКлиент.ПриИзмененииФИОФизическогоЛица(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СотрудникИзменилФИОНажатие(Элемент)	
	СотрудникиКлиент.ФизическоеЛицоИзменилФИОНажатие(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ГражданствоФизическихЛицИстория(Команда)
	СотрудникиКлиент.ОткрытьФормуРедактированияИстории("ГражданствоФизическихЛиц", ФизическоеЛицоСсылка, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДокументыФизическихЛицИстория(Команда)
	СотрудникиКлиент.ОткрытьФормуРедактированияИстории("ДокументыФизическихЛиц", ФизическоеЛицоСсылка, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ВсеДокументыЭтогоЧеловека(Команда)
	
	СотрудникиКлиент.ОткрытьСписокВсехДокументовФизическогоЛица(ЭтаФорма, ФизическоеЛицоСсылка);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	ЗаписатьНаКлиенте(Истина);	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписать(Команда)	
	ЗаписатьНаКлиенте(Ложь);      	
КонецПроцедуры

&НаКлиенте
Процедура Страхование(Команда)
	
	СотрудникиКлиент.ОткрытьДополнительнуюФорму(
	СотрудникиКлиентСервер.ОписаниеДополнительнойФормы("Справочник.ФизическиеЛица.Форма.Страхование"), ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеВБракеФизическихЛицИстория(Команда)
	СотрудникиКлиент.ОткрытьФормуРедактированияИстории("СостоянияВБракеФизическихЛиц", ФизическоеЛицоСсылка, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДублиНажатие(Элемент)
	ОбработатьСитуациюВыбораДубля(Элемент);
КонецПроцедуры

// Продедура открытия вспомогательной формы сравнения дублированных контрагентов.
// 
&НаКлиенте
Процедура ОбработатьСитуациюВыбораДубля(Элемент)
		
	ПараметрыПередачи = Новый Структура;
	ПараметрыПередачи.Вставить("ИНН", СокрЛП(ФизЛицо.ИНН));
	ПараметрыПередачи.Вставить("ЭтоЮрЛицо", Ложь);
	ПараметрыПередачи.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	
	ЧтоВыполнитьПослеЗакрытия = Новый ОписаниеОповещения("ОбработатьЗакрытиеФормыСпискаДублей", ЭтаФорма);
	
	ОткрытьФорму("Справочник.ФизическиеЛица.Форма.ФормаВыбораДублей", 
				  ПараметрыПередачи, 
				  Элемент,
				  ,
				  ,
				  ,
				  ЧтоВыполнитьПослеЗакрытия,
				  РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ЗаписатьИЗакрытьНаКлиенте(Результат, ДополнительныеПараметры) Экспорт 
	ЗаписатьНаКлиенте(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьЗакрытиеФормыСпискаДублей(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	ПроверитьДублиФизЛиц(ЭтаФорма);
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
    УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект, ФизЛицо);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДатаУвольненияСотрудника(Дата,ФизЛицо)
	
	ДатаУвольнения = Дата(1,1,1);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СотрудникиСрезПоследних.Период КАК ДатаУвольнения
		|ИЗ
		|	РегистрСведений.Сотрудники.СрезПоследних(&Период, ФизЛицо = &ФизЛицо) КАК СотрудникиСрезПоследних
		|ГДЕ
		|	СотрудникиСрезПоследних.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)";
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ДатаУвольнения = Выборка.ДатаУвольнения;
	КонецЕсли;		
	
	Возврат ДатаУвольнения;
	
КонецФункции // ДатаУвольненияСотрудника()

&НаКлиенте
Процедура ПроверитьИНН(Отказ = Ложь)
	
	СтруктураДляПроверкиИНН = Новый Структура(); 
	СтруктураДляПроверкиИНН.Вставить("ПроверитьИНН", 	ГражданствоФизическихЛиц.Страна = ПредопределенноеЗначение("Справочник.СтраныМира.Киргизия"));	
	СтруктураДляПроверкиИНН.Вставить("ИНН", 		 	ФизЛицо.ИНН);
	СтруктураДляПроверкиИНН.Вставить("ЕстьДубли",		Ложь);
	СтруктураДляПроверкиИНН.Вставить("Ссылка", 		 	ФизическоеЛицоСсылка);
	СтруктураДляПроверкиИНН.Вставить("ДатаРождения", 	ФизЛицо.ДатаРождения);
	СтруктураДляПроверкиИНН.Вставить("ЭтоЮрЛицо", 	 	Ложь);
	СтруктураВозврата = БухгалтерскийУчетКлиентСервер.ПроверитьКорректностьИНН(СтруктураДляПроверкиИНН);
	
	ПроверитьДублиФизЛиц(ЭтаФорма);	
	
	НадписьПоясненияНекорректногоИНН = СтруктураВозврата.НадписьПоясненияНекорректногоИНН;
	Элементы.НадписьПоясненияНекорректногоИНН.Видимость = Не СтруктураВозврата.ИННВВеденКорректно;
	
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////////
// Сервисные процедуры

&НаСервере
Процедура ПрочитатьНаборЗаписейПериодическихСведений(ИмяРегистра, ВедущийОбъект) Экспорт
	
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(ЭтаФорма, ИмяРегистра, ВедущийОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с дополнительными формами

&НаСервере
Функция АдресДанныхДополнительнойФормыНаСервере(ОписаниеДополнительнойФормы) Экспорт
	Возврат СотрудникиФормы.АдресДанныхДополнительнойФормы(ОписаниеДополнительнойФормы, ЭтаФорма);
КонецФункции

&НаСервере
Процедура ПрочитатьДанныеИзХранилищаВФормуНаСервере(Параметр) Экспорт
	
	СотрудникиФормы.ПрочитатьДанныеИзХранилищаВФорму(
	ЭтаФорма,
	СотрудникиКлиентСервер.ОписаниеДополнительнойФормы(Параметр.ИмяФормы),
	Параметр.АдресВХранилище);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаКлиенте(ЗакрытьПослеЗаписи, ОповещениеЗавершения = Неопределено) Экспорт 	
	ПараметрыЗаписи = Новый Структура;
	СотрудникиКлиент.ФизическиеЛицаПередЗаписью(ЭтаФорма, Ложь, ПараметрыЗаписи, ОповещениеЗавершения, ЗакрытьПослеЗаписи);	
КонецПроцедуры

// Процедура управляет информационными надписями о наличии дублей.
// 
&НаКлиентеНаСервереБезКонтекста
Процедура ПроверитьДублиФизЛиц(Форма)
	Объект = Форма.ФизЛицо;
	Элементы = Форма.Элементы;
	КоличествоЭлементовДублей = 0;
	
	КоличествоЭлементовДублей = ПолучитьКоличествоДублейСервер(Объект.ИНН, Объект.Ссылка);
	
	ЭтоЮрЛицо = Ложь;
	
	Если КоличествоЭлементовДублей > 0 Тогда
		
		СтруктураПараметровСообщенияОДублях = Новый Структура;
		
		Если КоличествоЭлементовДублей = 1 Тогда
			СтруктураПараметровСообщенияОДублях.Вставить("КоличествоЭлементовДублей", НСтр("ru = 'одно'"));
			СтруктураПараметровСообщенияОДублях.Вставить("СклонениеФизЛиц", НСтр("ru = 'ФизЛицо'"));
		ИначеЕсли КоличествоЭлементовДублей < 5 Тогда
			СтруктураПараметровСообщенияОДублях.Вставить("КоличествоЭлементовДублей", КоличествоЭлементовДублей);
			СтруктураПараметровСообщенияОДублях.Вставить("СклонениеФизЛиц", НСтр("ru = 'ФизЛица'"));
		Иначе
			СтруктураПараметровСообщенияОДублях.Вставить("КоличествоЭлементовДублей", КоличествоЭлементовДублей);
			СтруктураПараметровСообщенияОДублях.Вставить("СклонениеФизЛиц", НСтр("ru = 'ФизЦиц'"));
		КонецЕсли;	
		
		СтруктураПараметровСообщенияОДублях.Вставить("ИНН", НСтр("ru = 'ИНН'"));
		
		ТекстНадписиОДублях = НСтр("ru = 'С таким [ИНН] есть [КоличествоЭлементовДублей] [СклонениеФизЛиц]'");
		
		Элементы.ПоказатьДубли.Заголовок = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ТекстНадписиОДублях, СтруктураПараметровСообщенияОДублях);
		
		Если Не Форма.СтруктураДляПроверкиИНН = Неопределено Тогда 																										   
			Форма.СтруктураДляПроверкиИНН.ЕстьДубли = Истина;
			Элементы.ПоказатьДубли.Видимость = Истина;
		КонецЕсли;
	Иначе
		Если Не Форма.СтруктураДляПроверкиИНН = Неопределено Тогда 																										   
			Форма.СтруктураДляПроверкиИНН.ЕстьДубли = Ложь;
		КонецЕсли;
		
		Элементы.ПоказатьДубли.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКоличествоДублейСервер(Знач ИНН, Знач Ссылка)
	Если Ссылка = Справочники.ФизическиеЛица.ПустаяСсылка() Тогда 
		Ссылка = Справочники.ФизическиеЛица.ПолучитьСсылку(Новый УникальныйИдентификатор);
	КонецЕсли;

	Возврат Справочники.ФизическиеЛица.ПроверитьДублиИНН(СокрЛП(ИНН), Ссылка).Количество();
КонецФункции	

&НаСервере
Процедура СостоянияВБракеФизическихЛицСостояниеВБракеПриИзмененииНаСервере()
	Если СостоянияВБракеФизическихЛицПрежняя.СостояниеВБраке <> СостоянияВБракеФизическихЛиц.СостояниеВБраке Тогда
		СостоянияВБракеФизическихЛицНоваяЗапись = Истина;
		СостоянияВБракеФизическихЛиц.Период = Дата;
	КонецЕсли;
КонецПроцедуры // ()

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.КонтактнаяИнформация

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ПараметрыОткрытия = Новый Структура("Страна", ПредопределенноеЗначение("Справочник.СтраныМира.Киргизия"));
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка, ПараметрыОткрытия);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент,, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	УправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.АвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, Элемент.Имя, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат)
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, ФизЛицо, Результат);
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтактнаяИнформация

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры // Подключаемый_РедактироватьСоставСвойств()

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект, ФизЛицо);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект, ФизЛицо);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект, ФизЛицо);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти


