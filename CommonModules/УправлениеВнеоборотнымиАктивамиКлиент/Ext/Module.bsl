﻿#Область ПрограммныйИнтерфейс

// Открывает форму выбора справочника ОсновныеСредства с отбором ОС
// на указанную дату и в указанных, организации и подразделении
//
// Параметры:
//		ВладелецФормыВыбора					- Форма или элемент формы, для которого открывается форма выбора
//		Организация							- СправочникСсылка.Организации - , если не указана, в отбор попадают все сотрудники компании
//		Подразделение						- СправочникСсылка.ПодразделенияОрганизации - , если не указано - в отбор попадают все сотрудники
//		ДатаПримененияОтбора				- Дата - , на которую необходимо выбрать ОС
//      МножественныйВыбор					- Булево - , если ложь - форма откроется для выбора одного сотрудника
//		АдресСпискаПодобранныхСотрудников	- Строка - , адрес массива уже подобранных сотрудников во временном хранилище
//		СтруктураОтбора						- Структура - , аналогичная структуре отбора в параметрах формы списка
//
Процедура ВыбратьОСНаДату(ВладелецФормыВыбора, Организация = Неопределено, Подразделение = Неопределено, 
		МОЛ = Неопределено, Склад = Неопределено, Непринятые = Неопределено, ДатаПримененияОтбора = '00010101', 
		МножественныйВыбор = Истина, АдресСпискаПодобранныхОС = "", СтруктураОтбора = Неопределено) Экспорт
	
	Если СтруктураОтбора = Неопределено Тогда
		СтруктураОтбора = Новый Структура;
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(ДатаПримененияОтбора) Тогда
		СтруктураОтбора.Вставить("ДатаПримененияОтбора", ДатаПримененияОтбора);
	КонецЕсли; 
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("МножественныйВыбор", МножественныйВыбор);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", НЕ МножественныйВыбор);
		
	Если ЗначениеЗаполнено(Организация) Тогда
		СтруктураОтбора.Вставить("Организация", Организация);
	КонецЕсли; 
		
	Если ЗначениеЗаполнено(Подразделение) Тогда
		СтруктураОтбора.Вставить("Подразделение", Подразделение);
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(МОЛ) Тогда
		СтруктураОтбора.Вставить("МОЛ", МОЛ);
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(Склад) Тогда
		СтруктураОтбора.Вставить("Склад", Склад);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Непринятые) Тогда
		СтруктураОтбора.Вставить("Непринятые", Непринятые);
	КонецЕсли; 
	
	Если СтруктураОтбора.Количество() > 0 Тогда
		ПараметрыФормы.Вставить("Отбор", СтруктураОтбора);
	КонецЕсли;
	
	Если МножественныйВыбор И НЕ ПустаяСтрока(АдресСпискаПодобранныхОС) Тогда
		ПараметрыФормы.Вставить("АдресСпискаПодобранныхОС", АдресСпискаПодобранныхОС);
	КонецЕсли; 
	
	ОткрытьФорму("Справочник.ОсновныеСредства.ФормаВыбора", ПараметрыФормы, ВладелецФормыВыбора);	
	
КонецПроцедуры

#Область РаботаСПодбором

Процедура ОткрытьПодбор(ФормаВладелец, ИмяТабличнойЧасти) Экспорт
	
	ПараметрыПодбора = Новый Структура;
	Отказ = Ложь;
	
	ЗаполнитьЗначенияПараметровПодбора(ФормаВладелец, ИмяТабличнойЧасти, ПараметрыПодбора);
	
	Если НЕ Отказ Тогда
		ОписаниеОповещенияПриЗакрытииПодбора = Новый ОписаниеОповещения("ПриЗакрытииПодбора", ЭтотОбъект);
		ОткрытьФорму("Обработка.ПодборОС.Форма.Корзина", 
			ПараметрыПодбора, ФормаВладелец, Истина, , , ОписаниеОповещенияПриЗакрытииПодбора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьПодборКомплектацияОС(ФормаВладелец, ИмяТабличнойЧасти) Экспорт
	
	ПараметрыПодбора = Новый Структура;
	Отказ = Ложь;
	
	ЗаполнитьЗначенияПараметровПодбора(ФормаВладелец, ИмяТабличнойЧасти, ПараметрыПодбора);
	
	Если НЕ Отказ Тогда
		ОписаниеОповещенияПриЗакрытииПодбора = Новый ОписаниеОповещения("ПриЗакрытииПодбора", ЭтотОбъект);
		ОткрытьФорму("Обработка.ПодборОС.Форма.КорзинаКомплектацияОС", 
			ПараметрыПодбора, ФормаВладелец, Истина, , , ОписаниеОповещенияПриЗакрытииПодбора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

// Процедура обработки результатов закрытия подбора
//
Процедура ПриЗакрытииПодбора(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		Если НЕ ПустаяСтрока(РезультатЗакрытия.АдресКорзиныВХранилище) Тогда
			Оповестить("ПодборОСПроизведен", РезультатЗакрытия.АдресКорзиныВХранилище, РезультатЗакрытия.УникальныйИдентификаторФормыВладельца);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПриЗакрытииПодбора()

// Получение данных из форм-владельцев

Процедура ЗаполнитьЗначенияПараметровПодбора(ФормаВладелец, ИмяТабличнойЧасти, ПараметрыПодбора)
	
	ПараметрыПодбора.Вставить("ДокументСсылка", ФормаВладелец.ЭтотОбъект.Объект.Ссылка);
	ПараметрыПодбора.Вставить("Организация", ФормаВладелец.ЭтотОбъект.Объект.Организация);
	ПараметрыПодбора.Вставить("Дата", ФормаВладелец.ДатаДокумента);
	ПараметрыПодбора.Вставить("УникальныйИдентификаторФормыВладельца", ФормаВладелец.УникальныйИдентификатор);
	
	ЗаполнитьВидОперацииДокумента(ФормаВладелец, ПараметрыПодбора);
	ЗаполнитьПараметрВалютаДокумента(ФормаВладелец, ПараметрыПодбора);
	ЗаполнитьПараметрМестонахождение(ФормаВладелец, ПараметрыПодбора);
	ЗаполнитьДополнительныеПараметры(ФормаВладелец, ПараметрыПодбора);
	
	ЗаполнитьСписокПодобранных(ФормаВладелец, ПараметрыПодбора, ИмяТабличнойЧасти);
	
КонецПроцедуры

Процедура ЗаполнитьВидОперацииДокумента(ФормаВладелец, ПараметрыПодбора)
	Перем ВидОперации;
	
	Если ФормаВладелец.Объект.Свойство("ВидОперации", ВидОперации) Тогда
		
		ПараметрыПодбора.Вставить("ВидОперации", ВидОперации);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьСписокПодобранных(ФормаВладелец, ПараметрыПодбора, ИмяТабличнойЧасти)
	СписокПодобранных = Новый СписокЗначений;
	Для Каждого СтрокаТабличнойЧасти Из ФормаВладелец.Объект[ИмяТабличнойЧасти] Цикл 
		СписокПодобранных.Добавить(СтрокаТабличнойЧасти.ОсновноеСредство);
	КонецЦикла;
	
	ПараметрыПодбора.Вставить("СписокПодобранных", СписокПодобранных);		
КонецПроцедуры

Процедура ЗаполнитьПараметрВалютаДокумента(ФормаВладелец, ПараметрыПодбора)
	
	Если ФормаВладелец.Объект.Свойство("ВалютаДокумента") Тогда
		ПараметрыПодбора.Вставить("ВалютаДокумента", ФормаВладелец.Объект.ВалютаДокумента);
	Иначе
		ПараметрыПодбора.Вставить("ВалютаДокумента", Неопределено);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрМестонахождение(ФормаВладелец, ПараметрыПодбора)
	Перем Склад;
	Перем Подразделение;
	Перем МОЛ;
	
	Если СтрНайти(ФормаВладелец.ИмяФормы, "ПоступлениеТоваровУслуг") > 0 
		Или СтрНайти(ФормаВладелец.ИмяФормы, "ПринятиеКУчетуОС") > 0
		Или СтрНайти(ФормаВладелец.ИмяФормы, "ВводНачальныхОстатков") > 0
		Или СтрНайти(ФормаВладелец.ИмяФормы, "СчетНаОплатуПокупателю") > 0 Тогда
		
		ФормаВладелец.ЭтотОбъект.Объект.Свойство("Склад", Склад);
		ПараметрыПодбора.Вставить("Склад", Склад);
		
	ИначеЕсли СтрНайти(ФормаВладелец.ИмяФормы, "ИнвентаризацияОС") > 0
		Или СтрНайти(ФормаВладелец.ИмяФормы, "ПеремещениеОС") > 0
		Или СтрНайти(ФормаВладелец.ИмяФормы, "РеализацияТоваровУслуг") > 0
		Или СтрНайти(ФормаВладелец.ИмяФормы, "СписаниеОС") > 0 
		Или СтрНайти(ФормаВладелец.ИмяФормы, "КомплектацияОС") > 0 Тогда 
		
		ФормаВладелец.ЭтотОбъект.Объект.Свойство("Подразделение", Подразделение);
		ПараметрыПодбора.Вставить("Подразделение", Подразделение);
		
		Если НЕ ЗначениеЗаполнено(Подразделение) Тогда 
			ФормаВладелец.ЭтотОбъект.Объект.Свойство("ПодразделениеОтправитель", Подразделение);
			ПараметрыПодбора.Вставить("Подразделение", Подразделение);
		КонецЕсли;	
		
		ФормаВладелец.ЭтотОбъект.Объект.Свойство("МОЛ", МОЛ);
		ПараметрыПодбора.Вставить("МОЛ", МОЛ);
		
		Если НЕ ЗначениеЗаполнено(МОЛ) Тогда 
			ФормаВладелец.ЭтотОбъект.Объект.Свойство("МОЛОтправитель", МОЛ);
			ПараметрыПодбора.Вставить("МОЛ", МОЛ);
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДополнительныеПараметры(ФормаВладелец, ПараметрыПодбора)
	Перем СчетУчета;
	
	СостоянияОС = Новый СписокЗначений;
	
	Если ФормаВладелец.ИмяФормы = "Документ.ПоступлениеТоваровУслуг.Форма.ФормаДокументаОбщая" 
		Или ФормаВладелец.ИмяФормы = "Документ.АвансовыйОтчет.Форма.ФормаДокумента" Тогда
		
		СостоянияОС.Добавить("БезСостояния");
		
		ПараметрыПодбора.Вставить("ЭтоДокументПоступления", Истина);
		ПараметрыПодбора.Вставить("КонтролироватьМестонахождение", Ложь);
		
	ИначеЕсли ФормаВладелец.ИмяФормы = "Документ.ПринятиеКУчетуОС.Форма.ФормаДокумента" Тогда
		Если ПараметрыПодбора.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПринятияКУчетуОсновныхСредств.ОсновныеСредства") Тогда 
			СостоянияОС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыСостоянийОС.Поступило"));
			ПараметрыПодбора.Вставить("ЭтоДокументПоступления", Ложь);
		Иначе
			СостоянияОС.Добавить("БезСостояния");
			ПараметрыПодбора.Вставить("ЭтоДокументПоступления", Истина);
		КонецЕсли;
		
		ПараметрыПодбора.Вставить("КонтролироватьМестонахождение", Ложь);
		
	ИначеЕсли ФормаВладелец.ИмяФормы = "Документ.СписаниеОС.Форма.ФормаДокумента" Тогда
		Если ФормаВладелец.Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийСписанияОС.ПринятыеКУчетуОС") Тогда
			СостоянияОС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыСостоянийОС.ПринятоКУчету"));		
		ИначеЕсли ФормаВладелец.Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийСписанияОС.НеПринятыеКУчетуОС") Тогда	
			СостоянияОС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыСостоянийОС.Поступило"));		
		КонецЕсли;
		ПараметрыПодбора.Вставить("ЭтоДокументПоступления", Ложь);
		ПараметрыПодбора.Вставить("КонтролироватьМестонахождение", Истина);					
		
	ИначеЕсли ФормаВладелец.ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокумента"
		Или ФормаВладелец.ИмяФормы = "Документ.ИнвентаризацияОС.Форма.ФормаДокумента" 
		ИЛИ ФормаВладелец.ИмяФормы = "Документ.СчетНаОплатуПокупателю.Форма.ФормаДокумента" Тогда
		
		СостоянияОС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыСостоянийОС.ПринятоКУчету"));
		СостоянияОС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыСостоянийОС.Поступило"));		
		ПараметрыПодбора.Вставить("ЭтоДокументПоступления", Ложь);
		ПараметрыПодбора.Вставить("КонтролироватьМестонахождение", Ложь);
		
	ИначеЕсли ФормаВладелец.ИмяФормы = "Документ.КомплектацияОС.Форма.ФормаДокумента" Тогда 
		СостоянияОС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыСостоянийОС.Поступило"));
		СостоянияОС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыСостоянийОС.ПринятоКУчету"));
		СостоянияОС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыСостоянийОС.Передано"));
		СостоянияОС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыСостоянийОС.СнятоСУчета"));
		
		ПараметрыПодбора.Вставить("ЭтоДокументПоступления", Ложь);
		ПараметрыПодбора.Вставить("КонтролироватьМестонахождение", Истина);	
		
	Иначе 
		СостоянияОС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыСостоянийОС.Поступило"));
		СостоянияОС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыСостоянийОС.ПринятоКУчету"));
		СостоянияОС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыСостоянийОС.Передано"));
		СостоянияОС.Добавить(ПредопределенноеЗначение("Перечисление.ВидыСостоянийОС.СнятоСУчета"));
		
		ПараметрыПодбора.Вставить("ЭтоДокументПоступления", Ложь);
		ПараметрыПодбора.Вставить("КонтролироватьМестонахождение", Истина);
	КонецЕсли;
	
	ПараметрыПодбора.Вставить("СостоянияОС", СостоянияОС);		
	
КонецПроцедуры

// Конец Получение данных из форм-владельцев

#КонецОбласти

#КонецОбласти
